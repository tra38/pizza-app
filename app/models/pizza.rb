class Pizza
  include ActiveModel::Model
  include HttpRequest

  attr_accessor :id, :name, :description
  attr_reader :topping_ids

  validates_presence_of :name, :description

  def toppings
    if id
      query_for_toppings
    else
      []
    end
  end

  def topping_ids=(array)
    @topping_ids = array.delete_if(&:blank?).map(&:to_i)
  end

  def save
    if valid?
      data = { "name" => name, "description" => description }
      response = HttpRequest.post_request(data: data, uri_string: "https://pizzaserver.herokuapp.com/pizzas")
      self.id = response["id"]
      add_toppings(topping_ids)
    else
      false
    end
  end

  def update(pizza_params)
    self.topping_ids = pizza_params["topping_ids"]
    add_toppings(topping_ids)
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

  def add_toppings(topping_ids)
    topping_ids.each do |topping_id|
      data = { topping_id: topping_id}
      HttpRequest.post_request(data: data, uri_string: "https://pizzaserver.herokuapp.com/pizzas/#{id}/toppings")
    end
  end

end
