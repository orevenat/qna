class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      message = { notice: 'Your answer successfully removed.' }
    else
      message = { alert: "You can't delete this answer." }
    end

    redirect_to answer.question, message
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
    params.require(:answer).permit(:question, :body)
  end
end
