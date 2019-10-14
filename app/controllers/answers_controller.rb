# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  load_and_authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  delegate :destroy, to: :answer

  delegate :set_best, to: :answer

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:question, :body,
                                   files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{question.id}/answers",
      answer: answer,
      links: answer.links,
      rating: answer.rating
    )
  end
end
