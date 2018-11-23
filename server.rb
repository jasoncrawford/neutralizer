require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  headers 'Access-Control-Allow-Origin' => '*'
  text = request.body.read.force_encoding("UTF-8")
  Neutralizer.neutralize text
end
