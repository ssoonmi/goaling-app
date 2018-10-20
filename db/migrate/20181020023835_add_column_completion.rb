class AddColumnCompletion < ActiveRecord::Migration[5.2]
  def change
    add_column :goals, :complete, :boolean, default: false
  end
end
