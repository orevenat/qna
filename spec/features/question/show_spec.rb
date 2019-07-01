require 'rails_helper'

feature 'User can watch question and answers', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Not authenticated user can' do
    given(:answers) { create_list(:answers, 3, question: question, user: user) }

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
  end
end
