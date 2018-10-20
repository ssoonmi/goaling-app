class AddColumnLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :location, :string, null: false
    add_column :users, :house, :string, null: false
  end
end
