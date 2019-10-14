# frozen_string_literal: true

require 'rails_helper'

feature 'User can watch question and answers', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create(:link, name: 'Question link', linkable: question) }
  given(:answers) { create_list(:answer, 3, question: question, user: user) }
  given!(:answer_link) { create(:link, name: 'Answer link', linkable: answers.first) }

  context 'Not authenticated user can' do
    background do
      visit question_path(question)
    end

    scenario 'show current question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'watch list of answers' do
      expect(page).to have_content 'Answers:'

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end

    scenario "can't delete question link" do
      within "#link_#{link.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario "can't delete answer link's" do
      within "#link_#{answer_link.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  context 'Author can' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario "delete question link's", js: true do
      expect(page).to have_content link.name
      within "#link_#{link.id}" do
        page.accept_confirm do
          click_link 'Delete link'
        end
      end
      expect(page).to_not have_content link.name
    end

    scenario "can't delete answer link's" do
      within "#link_#{answer_link.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  context 'User(answer author)' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "can't delete question link's" do
      within "#link_#{link.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario "delete answer'link's", js: true do
      within "#link_#{answer_link.id}" do
        page.accept_confirm do
          click_link 'Delete link'
        end
      end

      expect(page).to_not have_link answer_link.name
    end
  end
end
