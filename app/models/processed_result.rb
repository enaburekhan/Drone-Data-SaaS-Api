class ProcessedResult < ApplicationRecord
  belongs_to :upload

  validates :result_type, :data_url, presence: true

  has_one :project, through: :upload
  has_one :user, through: :project
end
