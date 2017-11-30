require 'sinatra'

get '/' do
  "Hello world2"
end

get '/map' do
  erb :map
end
