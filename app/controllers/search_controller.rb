# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    @search_result = Services::Search.call(search_params)
    authorize! :search, @search_result
  end

  private

  def search_params
    params.permit(:q, :page, :per_page, :type)
  end
end
