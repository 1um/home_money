class AddDateToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :date, :date
  end
end
