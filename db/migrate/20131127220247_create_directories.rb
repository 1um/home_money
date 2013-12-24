class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.string :name
      t.integer :directories_purchases_id

      t.timestamps
    end
  end
end
