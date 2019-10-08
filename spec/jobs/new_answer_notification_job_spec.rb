require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('Services::NewAnswerNotification') }
  let(:answer) { create(:answer) }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
