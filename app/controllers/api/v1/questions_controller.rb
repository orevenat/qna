# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy]

  authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if question.destroy
      head :ok
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def questions
    @questions ||= Question.all
  end
end
