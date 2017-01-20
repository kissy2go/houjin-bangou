$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'vcr'
require 'houjin-bangou'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<APPLICATION_ID>') { ENV['HOUJIN_BANGOU_APPLICATION_ID'] }
end
