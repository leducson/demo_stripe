class Product < ApplicationRecord
  has_many :invoices, as: :serviceable
end
