Rails.application.routes.draw do
  resources :pizzas

  resources :toppings, only: [:new, :create]

  root 'pizzas#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
