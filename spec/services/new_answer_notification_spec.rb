require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'send notification of new answer to question author' do
    expect(QuestionMailer).to receive(:new_answer).with(user, question, answer).and_call_original

    subject.send_notification(answer)
  end
end
