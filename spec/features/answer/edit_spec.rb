require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'Unathenticated can no edit answer' do
    visit question_path(question)
    expect(page).to_not have_link  'Edit'
  end

  describe 'Authencicated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within "#answer-#{answer.id}" do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within "#answer-#{answer.id}" do
        fill_in 'Your answer', with: ''
        click_on 'Save answer'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end

    end

    scenario "tries to edit other users's question" do
      within "#answer-#{answer2.id}" do
        expect(page).to_not have_link  'Edit'
      end
    end
  end
end
