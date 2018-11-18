require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/http_mocks'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end
