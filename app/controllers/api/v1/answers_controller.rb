# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :answer, only: [:show]
  authorize_resource

  def show
    render json: answer
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end
end
