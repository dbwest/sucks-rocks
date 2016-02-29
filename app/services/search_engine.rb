class SearchEngine
  def self.count_results query
    bing = Bing::Search.new(ENV['BING_API_KEY'])
    result = bing.search(query).total_count.to_i
  end
end

require 'net/http'
require 'json'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Bing
  class Search
    BASE_URL = "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Composite?"
    SINGLE_QUOTE_ENCODED = "%27"

    def initialize(api_key)
      @api_key = api_key
    end

# $top can be removed for getting the first 50 results or more if specified!
    def search(query, sources = "web", format = "json", top = 1)
      url = "#{BASE_URL}Sources=#{stupid_encode(sources)}&Query=#{stupid_encode(query)}&$top=#{top}&$format=#{format}"
      json_result = execute_http_request(url)
      BingResult.new(json_result)
    end

    private

# must be replaced!
    def stupid_encode(value)
      "#{SINGLE_QUOTE_ENCODED}#{value}#{SINGLE_QUOTE_ENCODED}"
    end

    def execute_http_request(url)
      uri = URI(url)
      request = Net::HTTP::Get.new(uri.request_uri)
      username = "" # according to microsoft documentation!!!
      password = @api_key
      request.basic_auth(username, password)

      response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
        http.request(request)
      end
      response.body
    end
  end

  class BingResult
    def initialize(json_result)
      @result = JSON.parse(json_result)
    end

    def total_count
      @result["d"]["results"][0]["WebTotal"] || 0
    end
  end
end

