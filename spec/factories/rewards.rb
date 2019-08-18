FactoryBot.define do
  factory :reward do
    title { 'My reward' }
    image { fixture_file_upload(Rails.root.join('public', 'reward_logo.png'), 'reward_logo.png') }
    question { association(:question) }
  end
end
