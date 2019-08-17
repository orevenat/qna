# frozen_string_literal: true

class LinksController < ApplicationController
  def destroy
    if current_user.author_of?(resource)
      link.destroy
    else
      render status: :forbidden
    end
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end

  def resource
    @resource ||= link.linkable
  end
end
