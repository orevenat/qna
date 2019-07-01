require 'rails_helper'

feature 'User can destroy his own answer', %q{
  As an authenticated user
  I'd like to be able to remove his own answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'remove answer' do
      expect(page).to have_content answer.body

      click_on 'Remove answer'

      expect(page).to have_content 'Your answer successfully removed.'
      expect(page).to_not have_content answer.body
    end
  end

  describe 'Another user' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'remove a answer' do
      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Remove answer'
    end
  end

  scenario 'Unauthenticated user tries to remove a answer' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Remove answer'
  end
end
