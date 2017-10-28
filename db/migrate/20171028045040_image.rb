class Image < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.integer :all_story_id
      t.string  :url
      t.timestamps
    end

  end
end
