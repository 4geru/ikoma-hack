require 'sinatra'

get '/' do
  "Hello world"
end

get '/map' do
  erb :map
end