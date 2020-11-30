class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id'
  has_many :reactions, dependent: :destroy, as: :react_to

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :micropost_id, presence: true
  validates :parent_comment_id, presence: true, allow_nil: true
  validate :replies_should_not_have_reply

  scope :by_micropost, ->(id) { where(micropost_id: id) }
  scope :not_reply, -> { where(parent_comment_id: nil) }

  def replies_should_not_have_reply
    return unless parent_comment_id && Comment.find(parent_comment_id).parent_comment_id.present?

    errors.add(:discount, 'replies_should_not_have_reply')
  end

  def get_reaction(user_id)
    reactions.find_by(reactor_id: user_id)
  end
end
