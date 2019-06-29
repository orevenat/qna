require 'rails_helper'

feature 'User can watch question and ask answers', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'asks a question' do
      fill_in 'Body', with: 'answer text'
      click_on 'Send answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer text'
    end

    scenario 'asks a question with errors' do
      click_on 'Send answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'Not authenticated user can' do
    given(:answers) { create_list(:answers, 3, question: question, user: user) }

    background do
      visit question_path(question)
    end

    scenario 'watch list of answers' do

      expect(page).to have_content 'Answers:'

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end

    scenario 'Unauthenticated user tries to write answer' do
      click_on 'Send answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
