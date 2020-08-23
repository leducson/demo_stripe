class Invoice < ApplicationRecord
  belongs_to :serviceable, polymorphic: true

  enum status: [:no_invoice_due, :unpaid, :paid, :refuning, :refuned, :cancel]

  scope :newest, -> { order created_at: :desc }
end
