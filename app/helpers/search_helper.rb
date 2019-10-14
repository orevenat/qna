# frozen_string_literal: true

module SearchHelper
  def valid_types
    ['all'] + Services::Search::TYPES
  end
end
