# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :best, -> { order(best: :DESC) }

  def set_best
    transaction do
      question.answers.find_by(best: true)&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
