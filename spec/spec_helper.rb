require 'vcr'

RSpec.configure do |config|
  config.failure_color = :magenta
  config.tty = true
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
