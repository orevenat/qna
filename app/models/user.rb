# frozen_string_literal: true

class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def subscribed_of?(resource)
    resource.subscriptions.where(user: self).exists?
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
