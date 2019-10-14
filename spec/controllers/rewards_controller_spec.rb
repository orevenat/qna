# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:rewards) { create_list(:reward, 3, user: user) }

    context 'authenticated user' do
      before do
        login(user)
        get :index
      end

      it 'populates an array of all questions' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
