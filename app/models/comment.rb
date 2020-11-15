class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost, optional: true
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'super_comment_id'
  has_many :reactions, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :micropost_id, presence: true, allow_nil: true
  validates :super_comment_id, presence: true, allow_nil: true
  validate :micropost_id_or_super_comment_id_to_nil

  def micropost_id_or_super_comment_id_to_nil
    errors.add(:discount, 'neither micropost_id or super_comment_id must be nil') if (nil_micropost? && nil_super_comment?) || (!nil_micropost? && !nil_super_comment?)
  end

  def replies_should_not_have_reply
    errors.add(:discount, 'neither micropost_id or super_comment_id must be nil') if existed_relpy.first.micropost_id
  end

  def nil_micropost?
    micropost_id.nil?
  end

  def nil_super_comment?
    super_comment_id.nil?
  end

  scope :existed_relpy, -> { where(id: super_comment_id) }

  def get_reaction(user_id)
    reactions.find_by(reactor_id: user_id)
  end
end
