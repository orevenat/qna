class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best, -> { order(best: :DESC) }

  def set_best
    transaction do
      question.answers.find_by(best: true)&.update!(best: false)
      update!(best: true)
    end
  end
end
