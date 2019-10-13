module SearchHelper
  def valid_types
    ['all'] + Services::Search::TYPES
  end
end
