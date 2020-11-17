class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id'
  has_many :reactions, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :micropost_id, presence: true
  validates :parent_comment_id, presence: true, allow_nil: true
  validate  :replies_should_not_have_reply

  def replies_should_not_have_reply
    errors.add(:discount, 'replies_should_not_have_reply') if parent_comment_id && !Comment.find(parent_comment_id).parent_comment_id.nil?
  end

  def nil_micropost?
    micropost_id.nil?
  end

  def nil_super_comment?
    parent_comment_id.nil?
  end

  def get_reaction(user_id)
    reactions.find_by(reactor_id: user_id)
  end
end
