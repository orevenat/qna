# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates :url, format: { with: URI.regexp(%w[http https]) }

  def gist?
    url.match?(%r{^http(s?):\/\/gist.github.com\/\w+\/\w+})
  end

  def gist_content
    ::GistContentService.call(gist_id)
  end

  private

  def gist_id
    uri = URI.parse(url)

    uri.path.split('/').last
  end
end
