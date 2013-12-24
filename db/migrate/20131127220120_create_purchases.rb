class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.float :cost
      t.string :name
      t.integer :directories_purchases_id
      t.timestamps
    end
  end
end
