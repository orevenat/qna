class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :body, presence: true
end
