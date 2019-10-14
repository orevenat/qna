# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, :with_file, user: user) }
  let(:answer) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do
    context 'owner try' do
      before { login(user) }
      it 'remove file on his own question' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to change(question.files, :count).by(-1)
      end

      it 'remove file on his own answer' do
        expect { delete :destroy, params: { id: answer.files.first.id } }.to change(answer.files, :count).by(-1)
      end
    end

    context 'other user try' do
      before { login(another_user) }
      it 'remove file on his own question' do
        expect { delete :destroy, params: { id: question.files.first.id } }.to_not change(question.files, :count)
      end

      it 'remove file on his own answer' do
        expect { delete :destroy, params: { id: answer.files.first.id } }.to_not change(answer.files, :count)
      end
    end
  end
end
