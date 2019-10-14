# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up with omniauth providers', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up with omniauth providers
" do
  background { visit new_user_registration_path }

  describe 'with email' do
    %w[GitHub Vkontakte].each do |provider|
      scenario "User can sign with omniauth #{provider}" do
        expect(page).to have_content("Sign in with #{provider}")
        mock_auth_hash(provider)
        silence_omniauth { click_link "Sign in with #{provider}" }
        expect(page).to have_content("Successfully authenticated from #{provider.capitalize} account")
        expect(page).to have_content('')
      end

      scenario "User get message with #{provider} that invalid data" do
        expect(page).to have_content("Sign in with #{provider}")
        invalid_mock_auth_hash(provider)
        silence_omniauth { click_link "Sign in with #{provider}" }
        expect(page).to have_content("Could not authenticate you from #{provider} because \"Invalid credentials\"")
      end
    end
  end
end
