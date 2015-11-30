class AddColsToUserConsignees < ActiveRecord::Migration
  def change
    add_column :user_consignees, :remarks, :text, :null => false
    add_column :user_consignees, :created_at, :datetime
  end
end
