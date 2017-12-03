ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
class AllStory < ActiveRecord::Base
  has_many :photos
  has_many :users
end

class SelfStory < ActiveRecord::Base

end

class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :all_story
end

class User < ActiveRecord::Base
  has_many :photos
  belongs_to :all_story
  validates :user_id, uniqueness: true
end
