FactoryBot.define do
  sequence :title do |n|
    "question ##{n}"
  end

  factory :question do
    title
    body { "Text text text" }
    user { association(:user) }

    trait :with_file do
      file {
        fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
      }
    end

    trait :invalid do
      title { nil }
    end
  end
end
