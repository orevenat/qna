# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_resource
    resource_param = params.stringify_keys.keys.detect { |key| key.match?(/(\w+)_id/i) }&.gsub('_id', '')

    @resource = resource_param.classify.constantize.find(params["#{resource_param}_id".to_sym]) if %w[answer question].include?(resource_param)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      comment: @comment,
      created_at: @comment.created_at.strftime('%d-%m-%Y'),
      email: @comment.user.email
    )
  end
end
