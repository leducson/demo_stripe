class Invoice < ApplicationRecord
  belongs_to :product

  enum status: [:no_invoice_due, :unpaid, :paid, :refund, :cancel]
end
