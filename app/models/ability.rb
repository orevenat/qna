# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Answer, Comment, Question, User]
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, user

    can :create, [Answer, Comment, Question, Subscription]
    can :update, [Answer, Comment, Question], user_id: user.id
    can :destroy, [Answer, Comment, Question, Subscription], user_id: user.id

    can :set_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down vote_cancel], [Answer, Question] do |resource|
      !user.author_of?(resource)
    end
  end
end
