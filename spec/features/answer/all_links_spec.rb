require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/orevenat/29dec3ca96dea11e6293627ae7d155fe' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'answer text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
