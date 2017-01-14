require 'net/http'
require 'json'

module HttpRequest
  def self.json(key:, uri_string:)
    JSON.parse(get_request(key: key, uri_string: uri_string))
  end

  def self.get_request(key:, uri_string:)
    # APICache
    APICache.get(key, :cache => 300) do
      # http://stackoverflow.com/a/4581116/4765379
      url = URI.parse(uri_string)
      request = Net::HTTP::Get.new(url.to_s)
      response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
        http.request(request)
      }
      if response.code.to_i >= 200 && response.code.to_i < 400
        response.body
      else
        raise APICache::InvalidResponse
      end
    end
  end

end