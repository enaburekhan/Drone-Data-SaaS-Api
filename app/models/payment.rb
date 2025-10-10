class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :project

  before_validation :assign_defaults, on: :create

  validates :amount, :status, :provider, :transaction_id, presence: true
  validates :transaction_id, uniqueness: true

  enum :status, {
    pending: "pending",
    completed: "completed",
    failed: "failed",
    refunded: "refunded"
  }, validate: true

  def assign_defaults
    self.transaction_id ||= SecureRandom.uuid
    self.status ||= "pending"
  end

  # helper: store arbitrary data (like stripe session_id)
# def mark_success!(transaction_id:, metadata: {})
#   update(status: :succeeded, transaction_id, metadata)
# end

# def mark_failed!(metadata: {})
#   update(status: :failed, metadata)
# end
end


