require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json"} }
  let(:access_token) { create(:access_token) }
  let(:params) { { access_token: access_token.token } }

  describe 'GET /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, :with_file, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:files) { answer.files }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of comments' do
          expect(answer_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'return list of files' do
          expect(answer_response['files'].size).to eq files.size
        end

        it 'return url fields for question files' do
          expect(answer_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end
end
