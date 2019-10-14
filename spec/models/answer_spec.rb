# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:resource) { create(:answer) }
  end

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:reward) { create(:reward, question: question) }
    let(:another_question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }
    let(:another_question_answer) { create(:answer, question: another_question) }

    before { answer.set_best }

    it 'should mark answer as the best' do
      expect(answer).to be_best
    end

    it 'question reward must belong to answer author' do
      expect(reward.user).to eq answer.user
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

  describe 'question_author_notification' do
    let(:answer) { build(:answer) }

    it 'calls NewAnswerNotificationJob' do
      expect(NewAnswerNotificationJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
