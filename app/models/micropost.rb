class Micropost < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :destroy, as: :react_to
  # has_many :user_reaction, through: :reactions,source: :reactor
  has_many :comments
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes, message: 'should be less than 5MB' }

  CSV_ATTRIBUTES = %w[created_at content].freeze

  scope :last_month, -> { where(created_at: (Time.now - 1.month)..Time.now) }
  scope :by_user, ->(user) { where(user_id: user.id) }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def get_reaction(user_id)
    reactions.find_by(reactor_id: user_id)
  end

  def count_reaction
    Reaction.find_by_micropost(id).count
  end

  def comment_in_micropost
    Comment.not_reply.by_micropost(id)
  end
end
