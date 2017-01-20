require 'csv'

require 'houjin-bangou/version'

require 'houjin-bangou/immutable_struct'
require 'houjin-bangou/api_endpoint'
require 'houjin-bangou/result_set'
require 'houjin-bangou/util'

# @see http://www.houjin-bangou.nta.go.jp/webapi
# @see http://www.houjin-bangou.nta.go.jp/documents/k-web-api-kinou.pdf
module HoujinBangou
  @base_url     = "https://api.houjin-bangou.nta.go.jp/#{API_VERSION}"
  @open_timeout = 60
  @read_timeout = 60

  class << self
    attr_accessor :base_url, :application_id, :open_timeout, :read_timeout
  end

  def self.request(url, query, src_encoding: Encoding::Shift_JIS)
    query = { id: application_id }.merge(query)
    url.query = URI.encode_www_form(query)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    http.open_timeout = open_timeout
    http.read_timeout = read_timeout

    response = http.start do |http|
      request = Net::HTTP::Get.new(url.request_uri)
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      HoujinBangou::ResultSet.new(response.body, src_encoding)
    else
      response.value
    end
  end
end
