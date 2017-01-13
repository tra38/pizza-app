require 'net/http'

class Pizza
  include ActiveModel::Model

  attr_accessor :id, :name, :description

  validates_presence_of :id, :name, :description

  # def initialize(id:, name:, description:)
  #   @id = id
  #   @name = name
  #   @description = description
  # end

  def self.all
    pizzas = self.json(key: "all_pizzas", uri_string: "https://pizzaserver.herokuapp.com/pizzas").reject do |pizza|
      (pizza["name"].blank? || pizza["description"].blank?)
    end
    pizzas.map do |pizza|
      Pizza.new(id: pizza["id"], name: pizza["name"], description: pizza["description"])
    end
  end

  def self.find(pizza_id)
    self.json(key: "pizza_#{pizza_id}", uri_string: "https://pizzaserver.herokuapp.com/pizzas/#{pizza_id}/toppings")
  end

  private
  def self.json(key:, uri_string:)
    JSON.parse(get_request(key: key, uri_string: uri_string))
  end

  def self.get_request(key:, uri_string:)
    # APICache
    APICache.get(key, :cache => 300, :timeout => 20) do
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
