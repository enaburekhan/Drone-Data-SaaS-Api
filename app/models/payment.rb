class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :amount, :status, :provider, :transaction_id, presence: true
  validates :transaction_id, uniqueness: true

  enum status: {
    pending: "pending",
    completed: "completed",
    failed: "failed",
    refunded: "refunded"
  }
end
