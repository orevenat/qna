# frozen_string_literal: true

require 'rails_helper'

feature 'user can watch questions list', "
  As any user
  I'd like to be able to watch list of questions
" do
  given(:questions) { create_list(:question, 3) }

  background do
    questions
    visit questions_path
  end

  scenario 'Unauthenticated user tries to watch question list' do
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
