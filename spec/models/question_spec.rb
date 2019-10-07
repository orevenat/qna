require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:reward) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:resource) { create(:answer) }
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'question author_subscribe' do
    let(:author) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'author has subscription' do
      expect(author.subscribed_of?(question)).to be_truthy
    end

    it "other user don't have subscription" do
      expect(other_user.subscribed_of?(question)).to be_falsey
   end
  end
end
