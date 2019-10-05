require 'rails_helper'

describe 'Questions API', type: :request do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:headers) { { "ACCEPT" => "application/json"} }
  let(:params) { { access_token: access_token.token } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request sucessfull status'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/#id' do
    let(:question) { create(:question, :with_file) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let(:files) { question.files }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request sucessfull status'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it 'returns list of comments' do
          expect(question_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'return list of files' do
          expect(question_response['files'].size).to eq files.size
        end

        it 'return url fields for question files' do
          expect(question_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:params) { { access_token: access_token.token, question: question_params } }
    let(:question_params) { { title: "New title", body: "New body" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'post' }
    end

    context 'authorized' do
      context 'create with valid params' do
        before { post api_path, params: params, headers: headers }

        it_behaves_like 'Request sucessfull status'

        it 'saves a new question in the database' do
          expect(me.questions.count).to eq 1
        end

        it 'return all public fields' do
          %w[title body].each do |attr|
            expect(:question_response[attr]).to eq question_params[attr]
          end
        end
      end

      context 'create with invalid params' do
        let(:params) { { access_token: access_token.token,
                         question: { title: "New title", body: nil } } }

        before { post api_path, headers: headers, params: params }

        it 'return status :unprocessable_entity' do
          expect(response.status).to eq 422
        end

        it 'saves a new question in the database' do
          expect(Question.count).to eq 0
        end

        it 'return error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/question/:id' do
    let(:question_params) { { title: "New title", body: "New body" } }
    let(:params) { { access_token: access_token.token, question: question_params } }
    let(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'patch' }
    end

    context 'authorized' do
      context 'update with valid params' do
        before { patch api_path, headers: headers, params: params }

        it_behaves_like 'Request sucessfull status'
      end

      context 'update with invalid params' do
        let(:params) { { access_token: access_token.token,
                         question: { title: question.title, body: nil } } }

        before { patch api_path, headers: headers, params: params }

        it 'return status :unprocessable_entity' do
          expect(response.status).to eq 422
        end
      end
    end
  end
end
