# frozen_string_literal: true

require 'rails_helper'

feature 'User can destroy his own question', "
  As an authenticated user
  I'd like to be able to remove his own question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file, user: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'remove question' do
      expect(page).to have_content question.body

      click_on 'Remove question'

      expect(page).to have_content 'Your question successfully removed.'
      expect(page).to_not have_content question.body
    end

    scenario 'remove attached file' do
      filename = question.files.first.filename.to_s
      expect(page).to have_link 'Remove file'
      expect(page).to have_content filename

      click_on 'Remove file'

      expect(page).to have_content 'Your file succesfully removed.'
      expect(page).to_not have_content filename
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

    scenario 'remove a file' do
      filename = question.files.first.filename.to_s
      expect(page).to have_content filename
      expect(page).to_not have_link 'Remove file'
    end
  end

  scenario 'Unauthenticated user tries to remove a question' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to_not have_link 'Remove question'
  end
end
