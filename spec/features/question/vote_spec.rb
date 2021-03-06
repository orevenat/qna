# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for a question' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  context 'Authenticated user with another user question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote up for quesiton' do
      within '#question-area' do
        expect(page).to have_content('Rating value: 0')
        expect(page).to have_link('Up')
        expect(page).to have_link('Down')

        click_on 'Up'

        expect(page).to_not have_link('Up')
        expect(page).to_not have_link('Down')
        expect(page).to have_link('Cancel vote')
        expect(page).to have_content('Rating value: 1')
      end
    end

    scenario 'can vote down for quesiton' do
      within '#question-area' do
        expect(page).to have_content('Rating value: 0')
        expect(page).to have_link('Up')
        expect(page).to have_link('Down')

        click_on 'Down'

        expect(page).to_not have_link('Up')
        expect(page).to_not have_link('Down')
        expect(page).to have_link('Cancel vote')
        expect(page).to have_content('Rating value: -1')
      end
    end

    scenario 'can cancel vote' do
      question.vote_up(user)
      visit question_path(question)

      within '#question-area' do
        expect(page).to have_content('Rating value: 1')
        expect(page).to have_link('Cancel vote')
        expect(page).to_not have_link('Up')
        expect(page).to_not have_link('Down')

        click_on 'Cancel vote'

        expect(page).to have_link('Up')
        expect(page).to have_link('Down')
        expect(page).to_not have_link('Cancel vote')
        expect(page).to have_content('Rating value: 0')
      end
    end
  end

  scenario "Question author can't vote for his own question" do
    sign_in(author)
    visit question_path(question)

    within '#question-area' do
      expect(page).to have_content('Rating value: 0')
      expect(page).to_not have_link('Up')
      expect(page).to_not have_link('Down')
    end
  end
end
