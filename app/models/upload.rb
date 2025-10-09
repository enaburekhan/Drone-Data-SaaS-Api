class Upload < ApplicationRecord
  belongs_to :project
  has_many :processed_results, dependent: :destroy

  has_one_attached :file

  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }
end
