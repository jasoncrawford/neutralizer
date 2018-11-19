require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  request.body.read
end
