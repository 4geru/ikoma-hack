class Users < ActiveRecord::Migration
  def change
     create_table :users do |t|
      t.string :user_id
      t.timestamps null: false
    end
  end
end