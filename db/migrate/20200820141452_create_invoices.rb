class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :charge_id
      t.float :price
      t.integer :serviceable_id
      t.string :serviceable_type
      t.string :name
      t.integer :status
      t.string :reason

      t.timestamps
    end
  end
end
