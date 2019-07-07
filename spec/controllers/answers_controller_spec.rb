require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let!(:answer) { create(:answer, question: question, user: another_user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer with user author' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        end.to change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: another_user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'another user answer' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer2, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: another_user) }

    before { login(user) }

    context 'his own answer' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'another user answer' do
      it 'failed delete the answer' do
        expect { delete :destroy, params: { id: answer2 }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to current question' do
        delete :destroy, params: { id: answer2, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #set_best' do
    let!(:answer) { create(:answer, question: question, user: another_user) }

    context 'question author' do
      before { login(user) }

      it 'sets best to true' do
        post :set_best, params: {id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end

      it 'renders set_best template' do
        post :set_best, params: {id: answer }, format: :js
        expect(response).to render_template :set_best
      end
    end

    context 'another user' do
      before { login(another_user) }

      it "don't sets best to true" do
        post :set_best, params: {id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end
