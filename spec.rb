require 'rack/test'
require_relative 'server'

describe "server" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "is true" do
    expect(true).to be true
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
  end
end
