class Question < ApplicationRecord
  has_many :answer

  validates :title, :body, presence: true
end
