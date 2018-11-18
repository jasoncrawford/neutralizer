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
      post '/neutralize', "body"
    end

    it "should succeed" do
      expect(last_response).to be_ok
    end

    it "should echo the body" do
      expect(last_response.body).to eql('body')
    end
  end
end
