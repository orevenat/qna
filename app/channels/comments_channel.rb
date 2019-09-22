# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "questions/#{params['question_id']}/comments"
  end
end
