class Topping
  include ActiveModel::Model
  include HttpRequest

  attr_accessor :id, :name

  validates_presence_of :name

  def save
    if valid?
      data = { "name" => name }
      response = HttpRequest.post_request(data: data, uri_string: "https://pizzaserver.herokuapp.com/toppings")
      self.id = response["id"]
    else
      false
    end
  end

  def self.all
    # mocking some data so that we can actually TEST THIS OUT!
    # toppings = [ { "id" => 1, "name" => "blah" }, { "id" => 2, "name" => "DEMOCRACY"} ]
    toppings = HttpRequest.json(key: "all_toppings", uri_string: "https://pizzaserver.herokuapp.com/toppings")
    toppings.map do |topping|
      Topping.new(id: topping["id"], name: topping["name"])
    end
  end

end