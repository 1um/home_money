class AddFullPathToDirectories < ActiveRecord::Migration
  def change
  	add_column :directories, :full_path, :string
  	add_column :directories, :path_update, :string
  end
end
