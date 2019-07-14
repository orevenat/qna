require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: another_user ) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unathenticated can no edit question' do
    visit question_path(question)
    expect(page).to_not have_link  'Edit question'
  end

  describe 'Authencicated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit question'

      within "#question-area" do
        fill_in 'Your title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save question'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his question with attached files' do
      click_on 'Edit question'

      within "#question-area" do
        fill_in 'Your title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit question'

      within "#question-area" do
        fill_in 'Your question', with: ''
        click_on 'Save question'

        expect(page).to have_content question.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other users's question" do
      visit question_path(question2)

      within "#question-area" do
        expect(page).to_not have_link  'Edit question'
      end
    end
  end
end
