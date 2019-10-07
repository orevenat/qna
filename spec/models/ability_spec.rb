require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: other_question) }

    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:other_answer) { create(:answer, user: other_user, question: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, User }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }
    it { should be_able_to :update, create(:comment, user: user), user_id: user.id }
    it { should_not be_able_to :update, create(:comment, user: other_user), user_id: user.id }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :destroy, create(:comment, user: user), user_id: user.id }
    it { should_not be_able_to :destroy, create(:comment, user: other_user), user_id: user.id }
    it { should be_able_to :destroy, create(:subscription, user: user), user_id: user.id }
    it { should_not be_able_to :destroy, create(:subscription, user: other_user), user_id: user.id }

    context 'set the best' do
      it { should be_able_to :set_best, other_answer }
      it { should_not be_able_to :set_best, answer }
    end

    context 'vote and cancel vote' do
      it { should be_able_to :vote_up, other_answer }
      it { should_not be_able_to :vote_up, answer }
      it { should be_able_to :vote_down, other_answer }
      it { should_not be_able_to :vote_down, answer }
      it { should be_able_to :vote_cancel, other_answer }
      it { should_not be_able_to :vote_cancel, answer }

      it { should be_able_to :vote_up, other_question }
      it { should_not be_able_to :vote_up, question }
      it { should be_able_to :vote_down, other_question }
      it { should_not be_able_to :vote_down, question }
      it { should be_able_to :vote_cancel, other_question }
      it { should_not be_able_to :vote_cancel, question }
    end

    context 'my user profiles' do
      it { should be_able_to :me, user }
    end
  end
end
