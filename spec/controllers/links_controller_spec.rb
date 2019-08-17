# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'owner' do
      before { login(user) }

      it 'tries to delete his own link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
      end
    end

    context 'another user' do
      before { login(another_user) }

      it 'tries to delete link from another user question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(question.links, :count)
        expect(response).to have_http_status(403)
      end
    end
  end
end
