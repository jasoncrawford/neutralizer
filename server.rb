require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  neutralizer = Neutralizer.new
  text = request.body.read
  neutralizer.neutralize text
end
