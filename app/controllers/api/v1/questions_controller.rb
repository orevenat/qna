# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: [:show]

  authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def questions
    @questions ||= Question.all
  end
end
