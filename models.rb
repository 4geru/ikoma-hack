ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
class AllStory < ActiveRecord::Base

end

class SelfStory < ActiveRecord::Base

end

class Photo < ActiveRecord::Base

end
