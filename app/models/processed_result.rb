class ProcessedResult < ApplicationRecord
  belongs_to :upload

  validates :result_type, presence: true
  validates :data_url, presence: true

  has_one :project, through: :upload
  has_one :user, through: :project
end
