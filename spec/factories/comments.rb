# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :question
    sequence(:body) { |n| "comment ##{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
