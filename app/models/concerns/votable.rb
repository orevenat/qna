# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.find_or_create_by!(user: user).update!(value: 1)
  end

  def vote_down(user)
    votes.find_or_create_by!(user: user).update!(value: -1)
  end

  def vote_cancel(user)
    votes.find_or_create_by!(user: user).update!(value: 0)
  end

  def rating
    votes.sum(:value)
  end

  def user_already_voted?(user)
    votes.where(user: user).where('value != ?', 0).exists?
  end
end
