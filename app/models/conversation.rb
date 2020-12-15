class Conversation < ApplicationRecord
  serialize :members, Array
  has_many :messages, dependent: :destroy

  validate :check_unique_of_members
  validates :members, presence: true

  def check_unique_of_members
    return unless Conversation.where(members: members.reverse).any? || Conversation.where(members: members).any?

    errors.add(:discount, 'should unique members')
  end
end
