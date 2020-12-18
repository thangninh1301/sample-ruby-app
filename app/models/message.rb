class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :conversation_id, presence: true

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['photo'].blank? }
end
