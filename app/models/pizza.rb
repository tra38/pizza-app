class Pizza
  include ActiveModel::Model
  include HttpRequest

  attr_accessor :id, :name, :description

  validates_presence_of :id, :name, :description

  # def initialize(id:, name:, description:)
  #   @id = id
  #   @name = name
  #   @description = description
  # end

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
    pizza = HttpRequest.json(key: "pizza_#{pizza_id}", uri_string: "https://pizzaserver.herokuapp.com/pizzas").select do |pizza|
      (pizza["id"].to_i == pizza_id)
    end.first

    Pizza.new(id: pizza["id"], name: pizza["name"], description: pizza["description"])
  end
end
