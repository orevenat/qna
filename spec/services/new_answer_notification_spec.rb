require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:author) { create(:user) }
  let(:subscribed_user) { create(:user) }
  let(:unsubscribed_user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, user: subscribed_user, question: question) }

  it 'send notification of new answer to question author and other subscribers' do
    expect(QuestionMailer).to receive(:new_answer).with(author, question, answer).and_call_original.once
    expect(QuestionMailer).to receive(:new_answer).with(subscribed_user, question, answer).and_call_original.once
    expect(QuestionMailer).not_to receive(:new_answer).with(unsubscribed_user, question, answer)

    subject.send_notification(answer)
  end
end
