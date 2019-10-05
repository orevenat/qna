# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  load_and_authorize_resource :User

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles
  end

  def me
    render json: current_resource_owner
  end
end
