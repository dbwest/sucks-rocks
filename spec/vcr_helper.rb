VCR.config do |config|
  config.cassette_library_dir = "fixtures/cassettes"
  config.stub_with :webmock
  config.filter_sensitive_data("<BING API KEY>") { ENV.fetch("BING_API_KEY")}
end