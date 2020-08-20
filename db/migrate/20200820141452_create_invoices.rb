class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :charge_id
      t.float :price
      t.integer :product_id
      t.integer :status

      t.timestamps
    end
  end
end
