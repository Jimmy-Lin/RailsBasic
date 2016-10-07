class Link < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :folder

  validates :title, presence: true, length: { in: 1..255 }
  validates :creator, presence: true
  validates :folder, presence: true
  validates_associated :creator, :folder
end
