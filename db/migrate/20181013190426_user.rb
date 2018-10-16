class User < ActiveRecord::Migration[5.2]
  def change
  	create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.integer :group_id , null: true

      t.timestamps
    end
  end
end
