require 'sinatra'

get '/' do
  "Hello world2"
end

get '/map' do
  @story = AllStory.all
  @photo = []
  erb :map
end

get '/map/:id' do
  @story = User.find(params[:id]).photos.map{|photo| photo.all_story }
  @story = @story.select{|story| not story.lat.nil? }
  @photo = User.find(params[:id]).photos
  erb :map
end
