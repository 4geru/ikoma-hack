class UsersAddAllstoriesId < ActiveRecord::Migration[4.2]
  def change
    add_column(:users, :all_story_id, :integer)
  end
end
