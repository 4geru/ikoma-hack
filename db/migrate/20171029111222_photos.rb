class Photos < ActiveRecord::Migration[4.2]
  def change
     create_table :photos do |t|
      t.integer :user_id
      t.integer :all_story_id
      t.string  :url
      t.timestamps null: false
    end
  end
end
