class Plan < ApplicationRecord
  has_many :invoices, as: :serviceable
end
