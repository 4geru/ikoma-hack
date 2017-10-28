class AllStries < ActiveRecord::Migration
  def change
    create_table :all_stories do |t|
      t.integer :beacon_id
      t.string  :url
      t.string  :title
      t.string  :img
      t.string  :detail
      t.float   :lat
      t.float   :lng
    end
  end
end
