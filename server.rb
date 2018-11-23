require 'sinatra'
require_relative 'neutralizer'
require_relative 'cache'

set :neutralizer, Neutralizer.new
set :cache, Cache.new

get '/' do
  "hello, world!"
end

post '/neutralize' do
  cache_control :public, max_age: 300
  headers 'Access-Control-Allow-Origin' => '*'
  text = request.body.read.force_encoding("UTF-8")
  settings.neutralizer.neutralize text
end
