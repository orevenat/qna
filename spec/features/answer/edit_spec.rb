# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given(:link_url) { 'https://google.com' }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario "Unathenticated can't edit answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authencicated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'user try edit' do
      background do
        click_on 'Edit answer'
      end

      scenario 'edits his answer' do
        within "#answer-#{answer.id}" do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save answer'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea#answer_body'
        end
      end

      scenario 'can add link when editing answer' do
        within "#answer-#{answer.id}" do
          click_on 'Add link'
          fill_in 'Link name', with: 'New link name'
          fill_in 'Url', with: link_url
          click_on 'Save answer'

          expect(page).to have_link 'New link name', href: link_url
        end
      end

      scenario 'edit his answer with attached files' do
        within "#answer-#{answer.id}" do
          fill_in 'Your answer', with: 'edited answer'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save answer'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edits his answer with errors' do
        within "#answer-#{answer.id}" do
          fill_in 'Your answer', with: ''
          click_on 'Save answer'

          expect(page).to have_content answer.body
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea#answer_body'
        end
      end
    end

    scenario "tries to edit other users's question" do
      within "#answer-#{answer2.id}" do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end
end
