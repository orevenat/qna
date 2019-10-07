# frozen_string_literal: true

class QuestionMailer < ApplicationMailer
  def new_answer(user, question, answer)
    @user = user
    @answer = answer
    @question = question

    mail to: user.email
  end
end
