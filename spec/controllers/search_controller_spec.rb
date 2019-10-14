# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let!(:answers) { create_list(:answer, 3) }
  let(:search_text) { answers.first.body.truncate(5, omission: '').strip }

  describe 'GET #search' do
    it 'returns http success' do
      get :search, params: { q: 'search text', type: 'answer' }
      expect(response).to have_http_status(:success)
    end

    it 'should render search template' do
      get :search, params: { q: 'search text', type: 'answer' }
      expect(response).to render_template(:search)
    end

    context 'render all types correctly' do
      %w[question answer comment user].each do |type|
        it "type: #{type} search" do
          current_klass = type.classify.constantize
          expect(current_klass).to receive(:search).with(search_text, page: 1, per_page: 20)

          get :search, params: { q: search_text, type: type }
        end
      end
    end

    context 'render all and incorrect type' do
      %w[all wrong_type any_other_type].each do |type|
        it "type: #{type} search" do
          current_klass = ThinkingSphinx
          expect(current_klass).to receive(:search).with(search_text, page: 1, per_page: 20)

          get :search, params: { q: search_text, type: type }
        end
      end
    end
  end
end
