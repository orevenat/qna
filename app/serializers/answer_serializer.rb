# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
