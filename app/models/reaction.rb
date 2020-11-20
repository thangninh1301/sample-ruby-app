class Reaction < ApplicationRecord
  belongs_to :react_to, polymorphic: true
  belongs_to :reactor, class_name: 'User'
  validates :reactor_id, presence: true
  validates :icon_id, presence: true
  validate :icon_id_must_in_range

  def icon_id_must_in_range
    errors.add(:discount, 'icon_id_must_in_range 1-6') if icon_id > 6 || icon_id < 1
  end

  scope :find_existed, ->(reactor_id, react_to_type, react_to_id) { where(react_to_type: react_to_type, react_to_id: react_to_id, reactor_id: reactor_id) }
  scope :find_by_micropost, ->(id) { where(react_to_type: 'Micropost', react_to_id: id) }
end
