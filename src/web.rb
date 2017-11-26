require 'sinatra'

get '/' do
  "Hello world"
end

get '/map' do
  @story = AllStory.first
  @photos = Photo.first
  erb :map
end