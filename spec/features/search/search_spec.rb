require 'sphinx_helper'

feature 'User can find anything in search' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: question) }

  describe 'Search', js: true, sphinx: true do
    before { visit root_path }

    %w[question answer comment user].each do |type|
      scenario "User can find: #{type}" do
        current_klass = type.classify.constantize
        current_element = current_klass.first
        if current_klass == User
          search_result = User.first.email
          search_text = search_result.split('@').first
        else
          search_result = current_element.body
          search_text = search_result.split(' ').first
        end

        ThinkingSphinx::Test.run do
          within '.search-form' do
            fill_in 'q', with: search_text
            select type
            click_on 'Search'
          end

          within '.search-results' do
            expect(page).to have_content(search_result)
          end
        end
      end
    end
  end
end
