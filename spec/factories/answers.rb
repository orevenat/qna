FactoryBot.define do
  sequence :body do |n|
    "question ##{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end
  end
end
