# frozen_string_literal: true

module Subscriptionable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy, as: :resource
  end
end
