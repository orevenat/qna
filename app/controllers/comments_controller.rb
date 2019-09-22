# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create

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
end
