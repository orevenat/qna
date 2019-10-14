# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "question ##{n}"
  end

  factory :question do
    title
    body { 'Text text text' }
    user { association(:user) }

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      title { nil }
    end
  end
end
