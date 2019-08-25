# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  def vote_up
    resource.vote_up(current_user) unless author?

    render json: { rating: resource.rating, voted: true }
  end

  def vote_down
    resource.vote_down(current_user) unless author?

    render json: { rating: resource.rating, voted: true }
  end

  def vote_cancel
    resource.vote_cancel(current_user) unless author?

    render json: { rating: resource.rating, voted: false }
  end

  private

  def author?
    current_user.author_of?(resource)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def resource
    @resource ||= model_klass.find(params[:id])
  end
end
