# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  context 'Unregistred user tries sign up with errors' do
    scenario 'with empty email' do
      fill_in 'Password', with: 'password'
      fill_in 'Password', with: 'password'
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
    end

    scenario 'with wrong confirmation' do
      fill_in 'Email', with: 'test@yandex.ru'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'wrong_password'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'Unregistred user successfully sign up' do
    fill_in 'Email', with: 'test@yandex.ru'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
