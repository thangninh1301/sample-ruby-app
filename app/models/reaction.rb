class Reaction < ApplicationRecord
  belongs_to :micropost, class_name: 'Micropost'
  belongs_to :reactor, class_name: 'User'
  validates :reactor_id, presence: true
  validates :icon_id, presence: true
  validates :micropost_id, presence: true

  def self.get_id_by(reactor_id, micopost_id, icon_id)
    Reaction.find_by(icon_id: icon_id, reactor_id: reactor_id, micropost_id: micopost_id)
  end
end
