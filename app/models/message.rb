class Message < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :conversation

  validates :content, presence: true, length: { in: 1..2048 }
  validates :creator, presence: true
  validates :conversation, presence: true
  validates_associated :creator, :conversation
  validates :picture_size

  mount_uploader :picture, PictureUploader

  def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5MB")
      end
    end
end
