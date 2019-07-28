FactoryBot.define do
  factory :link do
    name { 'Link' }
    url { 'https://google.com' }

    trait :gist do
      name { 'Gist' }
      url { 'https://gist.github.com/orevenat/14e14db899be7db08178ddc5897b634e' }
    end
  end
end
