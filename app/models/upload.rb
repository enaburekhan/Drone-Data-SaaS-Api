class Upload < ApplicationRecord
  belongs_to :project
  has_many :processed_results, dependent: :destroy

  has_one_attached :file

  enum :status, %i[pending processing completed failed]
end
