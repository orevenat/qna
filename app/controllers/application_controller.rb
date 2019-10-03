# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, notice: exception.message }
      format.json { render json: exception.message, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
