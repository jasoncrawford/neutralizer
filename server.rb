require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  headers 'Access-Control-Allow-Origin' => '*'
  neutralizer = Neutralizer.new
  text = request.body.read
  neutralizer.neutralize text
end
