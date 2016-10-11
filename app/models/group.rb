class Group < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  has_many :memberships
  has_many :users, through: :memberships
  has_many :events
  has_many :announcements
  has_many :folder
  
  validates :title, presence: true, length: { in: 1..255 }
  validates :description, presence: true, length: { in: 1..2048 }
  validates :creator, presence: true
  validates_associated :creator
  validate :picture_size

  mount_uploader :picture, PictureUploader

  private
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5MB")
      end
    end
end
