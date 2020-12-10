class User < ApplicationRecord
  rolify
  attr_accessor :skip_password_validation

  after_create :add_admin_role

  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :trackable, :lastseenable,
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

  def online?
    last_seen && last_seen > 10.minutes.ago
  end

  # login with fb gg
  def self.from_omniauth(access_token, provider)
    data = access_token.info

    user = where(email: data['email']).first_or_create do |obj|
      obj.name = data['name']
      obj.email = data['email']
      obj.provider = provider
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

  private

  def add_admin_role
    add_role :admin if User.count == 1
    add_role :user
  end
end
