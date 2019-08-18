require 'rails_helper'

feature 'User can set best answer of his question', %q{
  In order to help other peoples with same question
  As an authenticated user and author of question
  I'd like to be able to set best answer to my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:reward) { create(:reward, user: user, question: question) }
  given!(:best_answer) { create(:answer, question: question) }
  given!(:another_best_answer) { create(:answer, question: question) }
  given!(:another_answer) { create(:answer, question: question) }

  context 'Authenticated author of question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'mark best answer to his question' do
      within "#answer-#{best_answer.id}" do
        click_on 'Set as best'

        expect(page).not_to have_content 'Set as best'
        expect(page).to have_content 'Best answer'
      end
      within "#answer-#{another_best_answer.id}" do
        expect(page).to have_content 'Set as best'
        expect(page).to_not have_content 'Best answer'
      end
      within "#answer-#{another_answer.id}" do
        expect(page).to have_content 'Set as best'
        expect(page).to_not have_content 'Best answer'
      end
    end

    scenario 'try mark another answer as best' do
      within "#answer-#{best_answer.id}" do
        click_on 'Set as best'

        expect(page).not_to have_content 'Set as best'
        expect(page).to have_content 'Best answer'
      end
      within "#answer-#{another_best_answer.id}" do
        expect(page).to have_content 'Set as best'
        expect(page).to_not have_content 'Best answer'

        click_on 'Set as best'

        expect(page).to_not have_content 'Set as best'
        expect(page).to have_content 'Best answer'
      end
      within "#answer-#{best_answer.id}" do
        expect(page).to have_content 'Set as best'
        expect(page).to_not have_content 'Best answer'
      end
      within "#answer-#{another_answer.id}" do
        expect(page).to have_content 'Set as best'
        expect(page).to_not have_content 'Best answer'
      end
    end
  end

  scenario 'Another authenticated user try set best answer' do
    visit question_path(question)
    sign_in(another_user)
    expect(page).to_not have_link 'Set as best'
  end

  scenario 'Unauthenticated user try set best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Set as best'
  end
end
