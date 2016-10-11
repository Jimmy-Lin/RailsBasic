class Document < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :folder

  validates :title, presence: true, length: { in: 1..255 }
  validates :creator, presence: true
  validates :folder, presence: true
  validates_associated :creator, :folder
  validates :document_size

  mount_uploader :source, DocumentUploader

  private
	def document_size
		if document.size > 25.megabytes
			error.add(:picture, "should be less than 25MB")
		end
	end
end
