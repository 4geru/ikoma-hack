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
  @photo = User.find(params[:id]).photos
  @story = @photo.map{|photo| photo.all_story }
  puts @story
  erb :map
end
