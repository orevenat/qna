class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :title, :body, presence: true
end
