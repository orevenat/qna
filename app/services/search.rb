# frozen_string_literal: true

module Services
  class Search
    include ShallowAttributes

    attribute :q, String
    attribute :page, Integer, default: 1
    attribute :per_page, Integer, default: 20
    attribute :type, String, default: 'all'

    TYPES = %w[question answer comment user].freeze

    def self.call(options = {})
      new(options).call
    end

    def call
      current_type.classify.constantize.search(q, page: page, per_page: per_page)
    end

    private

    def current_type
      case type
      when 'all'
        'thinking_sphinx'
      when *TYPES
        type
      else
        'thinking_sphinx'
      end
    end
  end
end
