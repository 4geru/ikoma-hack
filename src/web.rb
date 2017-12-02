require 'sinatra'

get '/' do
  "Hello world"
end

get '/map' do
  @story = AllStory.first
  @photos = Photo.first
  erb :map
end

get '/map/:id' do
  @story = User.find(params[:id]).photos.map{|photo| photo.all_story }
  puts @story
  @photos = Photo.first
  erb :map
end