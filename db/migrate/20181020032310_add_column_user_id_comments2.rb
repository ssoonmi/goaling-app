class AddColumnUserIdComments2 < ActiveRecord::Migration[5.2]
  def change
    add_index :comments, :user_id
  end
end
