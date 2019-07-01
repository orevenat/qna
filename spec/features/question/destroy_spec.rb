require 'rails_helper'

feature 'User can destroy his own question', %q{
  As an authenticated user
  I'd like to be able to remove his own question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'remove_question' do
      expect(page).to have_content question.body

      click_on 'Remove question'

      expect(page).to have_content 'Your question successfully removed.'
      expect(page).to_not have_content question.body
    end
  end

  describe 'Another user' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'remove a question' do
      expect(page).to have_content question.body
      expect(page).to_not have_link 'Remove question'
    end
  end

  scenario 'Unauthenticated user tries to remove a question' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to_not have_link 'Remove question'
  end
end
