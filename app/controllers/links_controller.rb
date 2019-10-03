# frozen_string_literal: true

class LinksController < ApplicationController
  skip_authorization_check

  def destroy
    if can?(:destroy, resource)
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
