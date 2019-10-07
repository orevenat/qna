# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.where('created_at > ?', Date.current - 1.day)

    mail to: user.email
  end
end
