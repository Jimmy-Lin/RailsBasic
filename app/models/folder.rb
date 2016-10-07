class Folder < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :group

  has_many :documents
  has_many :links

  validates :title, presence: true, length: { in: 1..255 }
  validates :creator, presence: true
  validates :group, presence: true
  validates_associated :creator, :group
end
