# frozen_string_literal: true

require 'rails_helper'

feature 'User can create a comment for a question or answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user creates comment for', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'question' do
      within '#question-area' do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'answer' do
      within '.answers' do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "question comments appears on another user's page" do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '#question-area' do
          fill_in 'Comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '#question-area' do
          expect(page).to have_content 'Test comment'
        end
      end
    end

    scenario "answers comments appears on another user's page" do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          fill_in 'Comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end

  describe 'Unauthenticated user tries to create comment for' do
    background do
      visit question_path(question)
    end

    scenario 'question' do
      within '#question-area' do
        expect(page).to_not have_button 'Add comment'
      end
    end

    scenario 'answer' do
      within '.answers' do
        expect(page).to_not have_button 'Add comment'
      end
    end
  end
end
