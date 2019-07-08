class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
  end

  def edit
  end

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
    question.update(question_params)
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
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= question.answers.new
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
