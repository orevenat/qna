require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:another_answer) { create(:answer, question: question) }
    let(:another_question_answer) { create(:answer, question: another_question) }

    before { answer.set_best }

    it 'should mark answer as the best' do
      expect(answer).to be_best
    end

    it "should't change marked answer" do
      another_question_answer.set_best
      answer.reload
      expect(answer).to be_best
    end

    it 'shold change best answer to new best answer' do
      another_answer.set_best
      answer.reload
      expect(answer).to_not be_best
      expect(another_answer).to be_best
    end
  end
end
