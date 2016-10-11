class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :group

  has_many :attendances
  has_many :users, through: :attendances

  validates :title, presence: true, length: { in: 1..255 }
  validates :description, presence: true, length: { in: 1..2048 }
  validates :is_datetime, presence: true
  validates :location, presence: true, length: { in: 1..255 }
  validates :is_public, presence: true
  validates :creator, presence: true
  validates :group, presence: true
  validates :time, presence: true
  validates_associated :creator, :group
  validates :picture_size

  mount_uploader :picture, PictureUploader

  private
    def is_datetime?
	    errors.add(:time, 'Must be a valid datetime') if ((DateTime.parse(:time) rescue ArgumentError) == ArgumentError)
	  end

    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5MB")
      end
    end
end
