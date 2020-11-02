class Micropost < ApplicationRecord
  belongs_to :user
  has_many :reactions, class_name: 'Reaction',
                       foreign_key: 'micropost_id',
                       dependent: :destroy
  # has_many :user_reaction, through: :reactions,source: :reactor

  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'should be less than 5MB' }
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def get_reaction_id(icon_id, user_id)
    reactions.find_by(icon_id: icon_id, reactor_id: user_id)
  end

  def count_reaction_by_icon(icon_id)
    Reaction.where(micropost_id: id, icon_id: icon_id).count
  end
end
