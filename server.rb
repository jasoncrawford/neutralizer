require 'sinatra'

get '/' do
  "hello, world!"
end

post '/neutralize' do
  request.body
end
