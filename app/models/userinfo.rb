class Userinfo < ApplicationRecord
  belongs_to :user
  validates :email, presence: true
  validates :name, presence: true
  validates :datafrom, presence: true
end
