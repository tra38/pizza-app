class Pizza
  include ActiveModel::Model
  include HttpRequest

  attr_accessor :id, :name, :description

  validates_presence_of :name, :description

  def toppings
    if id
      query_for_toppings
    else
      []
    end
  end

  def topping_ids
    toppings.each do |topping|
      topping.id
    end
  end

  def save
    if valid?
      data = { "name" => name, "description" => description }
      response = HttpRequest.post_request(data: data, uri_string: "https://pizzaserver.herokuapp.com/pizzas")
      self.id = response["id"]
    else
      false
    end
  end

  def self.all
    pizzas = HttpRequest.json(key: "all_pizzas", uri_string: "https://pizzaserver.herokuapp.com/pizzas").reject do |pizza|
      (pizza["name"].blank? || pizza["description"].blank?)
    end
    pizzas.map do |pizza|
      Pizza.new(id: pizza["id"], name: pizza["name"], description: pizza["description"])
    end
  end

  def self.find(pizza_id)
    pizza_id = pizza_id.to_i

    # Need to find a more efficent way of filtering by specific pizza
    pizza = HttpRequest.json(key: "all_pizzas", uri_string: "https://pizzaserver.herokuapp.com/pizzas").select do |pizza|
      (pizza["id"].to_i == pizza_id)
    end.first

    Pizza.new(id: pizza["id"], name: pizza["name"], description: pizza["description"])
  end

  private
  def query_for_toppings
    begin
      toppings = HttpRequest.json(key: "pizza_#{id}", uri_string: "https://pizzaserver.herokuapp.com/pizzas/#{id}/toppings")
      toppings.map do |topping|
        Topping.new(id: topping["id"], name: topping["name"])
      end
    rescue APICache::InvalidResponse
      []
    end
  end

end
