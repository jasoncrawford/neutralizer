require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  neutralizer = Neutralizer.new
  request.body.read
end
