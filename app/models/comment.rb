class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent_comment_id, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'super_comment_id'
  has_many :reactions, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :micropost_id, presence: true
  validates :super_comment_id, presence: true, allow_nil: true
  validate  :replies_should_not_have_reply

  def replies_should_not_have_reply
    errors.add(:discount, 'replies_should_not_have_reply') if super_comment_id && !Comment.find(super_comment_id).super_comment_id.nil?
  end

  def nil_micropost?
    micropost_id.nil?
  end

  def nil_super_comment?
    super_comment_id.nil?
  end

  def get_reaction(user_id)
    reactions.find_by(reactor_id: user_id)
  end
end
