class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :plan_stripe_id
      t.string :name
      t.decimal :price
      t.string :interval

      t.timestamps
    end
  end
end
