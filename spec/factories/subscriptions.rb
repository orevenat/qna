FactoryBot.define do
  factory :subscription do
    user
    association :resource, factory: :question
  end
end
