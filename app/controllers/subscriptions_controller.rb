# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :resource, only: :create
  before_action :subscription, only: :destroy

  authorize_resource

  def create
    @subscription = @resource.subscriptions.create(user: current_user)
  end

  def destroy
    subscription.destroy
  end

  private

  def resource
    @resource ||= Question.find(params[:question_id])
  end

  def subscription
    @subscription ||= current_user.subscriptions.find(params[:id])
  end

  helper_method :resource, :subscription
end
