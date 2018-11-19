require 'rack/test'
require_relative '../server'

describe "server" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "neutralize" do
    before do
      post '/neutralize', "She thinks he will"
    end

    it "should succeed" do
      expect(last_response).to be_ok
    end

    it "should neutralize the body" do
      expect(last_response.body).to eql('They think they will')
    end
  end
end
