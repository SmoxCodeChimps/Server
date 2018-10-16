class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :tracker_name
      t.string :tracker_id

      t.timestamps
    end
  end
end
