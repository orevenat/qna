# frozen_string_literal: true

require 'rails_helper'

feature 'User can destroy his own answer', "
  As an authenticated user
  I'd like to be able to remove his own answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'remove answer', js: true do
      expect(page).to have_content answer.body

      within "#answer-#{answer.id}" do
        click_on 'Remove answer'
      end

      a = page.driver.browser.switch_to.alert
      expect(a.text).to eq('Are you sure?')
      a.accept
      expect(page).to_not have_content answer.body
    end

    scenario 'remove attached file' do
      filename = answer.files.first.filename.to_s

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Remove file'
        expect(page).to have_content filename

        click_on 'Remove file'

        expect(page).to_not have_content filename
      end

      expect(page).to have_content 'Your file succesfully removed.'
    end
  end

  describe 'Another user', js: true do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'remove a answer' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Remove answer'
      end
    end

    scenario 'remove attached file' do
      within "#answer-#{answer.id}" do
        filename = answer.files.first.filename.to_s

        expect(page).to have_content filename
        expect(page).to_not have_link 'Remove file'
      end
    end
  end

  scenario 'Unauthenticated user tries to remove a answer', js: true do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Remove answer'
    end
  end
end
