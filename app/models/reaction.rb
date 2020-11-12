class Reaction < ApplicationRecord
  belongs_to :micropost, class_name: 'Micropost'
  belongs_to :reactor, class_name: 'User'
  validates :reactor_id, presence: true
  validates :icon_id, presence: true
  validates :micropost_id, presence: true, allow_nil: true
  validates :comment_id, presence: true, allow_nil: true
  validate :micropost_id_or_comment_id_to_nil,
           :icon_id_must_in_range

  def micropost_id_or_comment_id_to_nil
    errors.add(:discount, 'neither micropost_id_or_comment_id must be nil') if (micropost_id.nil? && comment_id.nil?) || (!micropost_id.nil? && !comment_id.nil?)
  end

  def icon_id_must_in_range
    errors.add(:discount, 'icon_id_must_in_range 1-6') if icon_id > 6 || icon_id < 1
  end

  scope :find_existed, ->(reactor_id, micropost_id) { where(reactor_id: reactor_id, micropost_id: micropost_id) }
end
