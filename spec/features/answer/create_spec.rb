# frozen_string_literal: true

require 'rails_helper'

feature 'User can give an answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create answer to question' do
      fill_in 'Your answer', with: 'answer text'
      click_on 'Send answer'

      within '.answers' do
        expect(page).to have_content 'answer text'
      end
    end

    scenario 'asks a question with attached file' do
      fill_in 'Your answer', with: 'answer text'

      attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
      click_on 'Send answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'create answer to question with errors' do
      click_on 'Send answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        fill_in 'Your answer', with: 'answer text multiple'
        click_on 'Send answer'

        within '.answers' do
          expect(page).to have_content 'answer text multiple'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text multiple'
      end
    end
  end

  context 'Not authenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'tries to write answer' do
      click_on 'Send answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
