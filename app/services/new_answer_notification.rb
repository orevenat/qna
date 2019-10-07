# frozen_string_literal: true

module Services
  class NewAnswerNotification
    def send_notification(answer)
      question = answer.question
      subscriptions = question.subscriptions

      subscriptions.find_each do |subscription|
        QuestionMailer.new_answer(subscription.user, question, answer).deliver_later
      end
    end
  end
end
