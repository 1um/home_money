class RemoveDirectoriesPurchasesIdFromDirectories < ActiveRecord::Migration
  def change
  	remove_column :directories, :directories_purchases_id
  	remove_column :purchases, :directories_purchases_id
  	create_table :directories_purchases do |t|
      t.integer :purchase_id
      t.integer :directory_id
    end
  end
end
