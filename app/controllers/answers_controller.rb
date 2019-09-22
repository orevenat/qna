# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def set_best
    answer.set_best if current_user.author_of?(answer.question)
  end

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
