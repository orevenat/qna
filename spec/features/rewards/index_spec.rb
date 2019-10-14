# frozen_string_literal: true

require 'rails_helper'

feature 'user can watch his rewards list', "
  As authenticated user
  I'd like to be able to watch list of my rewards
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:rewards) { create(:reward, user: user) }

  context 'Authenticated user ' do
    background do
      sign_in(user)
      visit rewards_path
    end

    scenario 'tries to watch rewards list' do
      expect(page).to have_content rewards.title
    end
  end

  context 'User that not have rewards yet' do
    background do
      sign_in(another_user)
      visit rewards_path
    end

    scenario ' try to watch rewards list' do
      expect(page).to have_content 'Your rewards'
      expect(page).to_not have_content rewards.title
    end
  end

  scenario 'Unauthenticated user tries to watch rewards list' do
    visit rewards_path

    expect(page).to_not have_content rewards.title
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
