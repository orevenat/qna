# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    answer.links.new
  end

  def new
    question.links.new
    question.build_reward
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to root_path, notice: 'Your question successfully removed.'
    else
      redirect_to question, alert: "You can't delete this question."
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= question.answers.new
  end

  helper_method :question, :answer

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_link',
        locals: { question: question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[title image])
  end
end
