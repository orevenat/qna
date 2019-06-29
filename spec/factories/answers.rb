FactoryBot.define do
  sequence :body do |n|
    "answer ##{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end
  end
end
