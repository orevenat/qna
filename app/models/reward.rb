# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
end
