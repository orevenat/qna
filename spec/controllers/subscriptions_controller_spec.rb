# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      it 'create new subscription to this question' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
      end

      it 'create new subscription to this user' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'not authenticated user' do
      it 'not change subscriptions count' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }

    context 'authenticated user' do
      before { login(user) }

      it 'remove question subscription from database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 'remove user subscription from database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'not authenticated user' do
      it 'not change subscriptions count' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
