# frozen_string_literal: true

class GistContentService
  attr_reader :gist_id

  def initialize(gist_id)
    @gist_id = gist_id
  end

  def self.call(gist_id)
    new(gist_id).call
  end

  def call
    gist_content
  end

  private

  def gist_content
    client.gist(gist_id).files.map do |_k, v|
      v[:content]
    end.join('')
  end

  def client
    Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end
end
