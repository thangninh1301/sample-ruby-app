class Conversation < ApplicationRecord
  serialize :members, Array
  has_many :messages
end
