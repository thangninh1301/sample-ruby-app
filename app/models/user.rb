class User < ApplicationRecord
  rolify
  resourcify
  attr_accessor :skip_password_validation

  # Include default devise modules. Others available are:
  # ,  and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  has_many :user_info, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, class_name: 'Reaction',
                       foreign_key: 'reactor_id',
                       dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  CSV_ATTRIBUTES = %w[created_at name].freeze
  # Returns the hash digest of the given string.

  # login with fb gg
  def self.from_omniauth(access_token, provider)
    data = access_token.info

    user = where(email: data['email']).first_or_create do |obj|
      obj.name = data['name']
      obj.email = data['email']
      obj.provider = provider
      #  If you are using confirmable and the provider(s) you use validate emails
      obj.skip_confirmation!
    end

    user.skip_password_validation = true
    user.save

    if user.persisted?
      user.user_info.where(provider: provider).first_or_create(name: data['name'],
                                                               email: data['email'],
                                                               avatar_url: data['image'],
                                                               provider: provider)
    end
    user
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def following_last_month
    following_ids = Relationship.last_month.where(follower_id: id).pluck(:followed_id)
    User.where(id: following_ids)
  end

  def followed_last_month
    follower_ids = Relationship.last_month.where(followed_id: id).pluck(:follower_id)
    User.where(id: follower_ids)
  end

  def feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Micropost.where("user_id IN (#{following_ids})
                      OR user_id = :user_id", user_id: id)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  protected

  def password_required?
    return false if skip_password_validation

    super
  end
end
