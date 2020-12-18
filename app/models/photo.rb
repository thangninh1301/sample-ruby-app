class Photo < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  validates_presence_of :photo

  belongs_to :message
end
