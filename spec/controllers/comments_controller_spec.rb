# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, user: user, commentable: question) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        end.to change(question.comments, :count).by(1)
      end

      it 'saves a new comment with user author' do
        expect do
          post :create, params: { comment: attributes_for(:answer), question_id: question }, format: :js
        end.to change(user.comments, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.
            to_not change(question.comments, :count)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
