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

    it "should allow CORS" do
      expect(last_response.headers['Access-Control-Allow-Origin']).to eq('*')
    end

    it "should not allow cache?" do
      expect(last_response.headers['Cache-Control']).to eq('public, max-age=300')
    end

    it "should neutralize the body" do
      expect(last_response.body).to eql('They think they will')
    end

    context "with special characters" do
      before do
        post '/neutralize', "Won’t you handle “special” characters—please?"
      end

      it "should succeed" do
        expect(last_response).to be_ok
      end
    end
  end
end
