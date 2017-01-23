module PizzasHelper

  def print_toppings(toppings)
    if toppings.empty?
      "None"
    else
      toppings.map do |topping|
        topping.name
      end.join(", ")
    end
  end
end
