class Makegroupidnullable < ActiveRecord::Migration[5.2]
  def change
  	change_column :users, :group_id, :integer, :null => true
  end
end
