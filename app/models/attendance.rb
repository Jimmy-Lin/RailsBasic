class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :group, presence: true
  validates_associated :user, :group
end
