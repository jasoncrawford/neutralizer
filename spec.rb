require 'rack/test'
require_relative 'server'

describe "server" do
  include Rack::Test::Methods

  it "is true" do
    expect(true).to be true
  end
end
