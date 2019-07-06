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

    scenario 'create answer to question with errors' do
      click_on 'Send answer'
      expect(page).to have_content "Body can't be blank"
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
