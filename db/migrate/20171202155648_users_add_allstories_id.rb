class UsersAddAllstoriesId < ActiveRecord::Migration[5.1]
  def change
    add_column(:users, :all_story_id, :integer)
  end
end
