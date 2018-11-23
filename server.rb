require 'sinatra'
require_relative 'neutralizer'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  headers 'Access-Control-Allow-Origin' => '*'
  @neutralizer ||= Neutralizer.new
  text = request.body.read.force_encoding("UTF-8")
  @neutralizer.neutralize text
end
