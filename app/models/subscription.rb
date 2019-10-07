# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :resource, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[resource_id resource_type] }
end
