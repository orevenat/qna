FactoryBot.define do
  factory :answer do
    body { "MyText2" }

    trait :invalid do
      body { nil }
    end
  end
end
