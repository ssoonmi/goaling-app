class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.text :description
      t.string :title, null: false
      t.boolean :public, null: false, default: true
    end

    add_index :goals, :user_id
  end
end
