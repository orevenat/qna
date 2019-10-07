# frozen_string_literal: true

module Services
  class NewAnswerNotification
    def send_notification(answer)
      question = answer.question
      user = question.user
      QuestionMailer.new_answer(user, question, answer).deliver_later
    end
  end
end
