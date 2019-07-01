FactoryBot.define do
  sequence :title do |n|
    "question ##{n}"
  end

  factory :question do
    title
    body { "Text text text" }

    trait :invalid do
      title { nil }
    end
  end
end
