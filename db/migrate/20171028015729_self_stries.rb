class SelfStries < ActiveRecord::Migration[5.1]
  def change
    create_table :self_stories do |t|
      t.string  :url
      t.string  :title
      t.string  :img
      t.string  :detail
      t.float   :lat
      t.float   :lng
    end
  end
end
