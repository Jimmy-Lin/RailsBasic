class Announcement < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :group

  validates :title, presence: true, length: { in: 1..255 }
  validates :description, presence: true, length: { in: 1..2048 }
  validates :is_public, presence: true
  validates :creator, presence: true
  validates :group, presence: true
  validates_associated :creator, :group
end
