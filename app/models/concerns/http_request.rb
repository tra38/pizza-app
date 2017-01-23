require 'net/http'
require 'json'

module HttpRequest
  def self.json(key:, uri_string:)
    JSON.parse(get_request(key: key, uri_string: uri_string))
  end

  def self.get_request(key:, uri_string:)
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

  def self.post_request(data:, uri_string:)
    #http://stackoverflow.com/a/23676892/4765379
    url = URI.parse(uri_string)
    request = Net::HTTP::Post.new(url.to_s, 'Content-Type' => 'application/json')
    request.body = data.to_json
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      JSON.parse(response.body)
    else
    end
  end

end