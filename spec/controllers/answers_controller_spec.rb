require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#POST create' do
    let!(:answer) { create(:answer, question: question, user: another_user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template "questions/show", "layouts/application"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: another_user) }

    before { login(user) }

    context 'his own answer' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'another user answer' do
      it 'failed delete the answer' do
        expect { delete :destroy, params: { id: answer2 } }.to_not change(Answer, :count)
      end

      it 'redirects to current question' do
        delete :destroy, params: { id: answer2 }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
