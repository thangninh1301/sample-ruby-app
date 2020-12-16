class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  validate :unique_revert_conversation

  def unique_revert_conversation
    return unless Conversation.where(sender_id: receiver_id, receiver_id: sender_id).any?

    errors.add(:discount, 'unique_revert_conversation')
  end
end
