# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_applications, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '12345678' }
    secret { '8751231412' }
  end
end
