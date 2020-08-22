class Invoice < ApplicationRecord
  belongs_to :product

  enum status: [:no_invoice_due, :unpaid, :paid, :refuning, :refuned, :cancel]

  delegate :name, to: :product, prefix: true

  scope :newest, -> { order created_at: :desc }
end
