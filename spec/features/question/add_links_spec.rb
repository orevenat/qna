# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/orevenat/14e14db899be7db08178ddc5897b634e' }
  given(:gist_content) { 'Gist text - gist text' }
  given(:urls) { ['https://google.com', 'https://yandex.ru'] }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds gist link when asks question', js: true do
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content gist_content
    expect(page).to_not have_link 'My gist', href: gist_url
  end

  scenario 'User adds links when asks question', js: true do
    expect(page).to have_link 'Add link'

    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'
    click_on 'Add link'

    all('.nested-fields').each_with_index do |nested, index|
      within nested do
        fill_in 'Link name', with: "My link # #{index + 1}"
        fill_in 'Url', with: urls[index]
      end
    end

    click_on 'Ask'

    urls.each_with_index do |url, index|
      expect(page).to have_link "My link # #{index + 1}", href: url
    end
  end
end
