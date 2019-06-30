class Question < ApplicationRecord
  has_many :answers
  belongs_to :user, dependent: :destroy

  validates :title, :body, presence: true
end
