class ToppingsController < ApplicationController
  rescue_from Http::InvalidResponse, with: :heroku_down

  def new
    @topping = Topping.new
  end

  # POST /pizzas
  # POST /pizzas.json
  def create
    @new_topping = Topping.new(topping_params)

    respond_to do |format|
      if @new_topping.save
        format.html { redirect_to "/", notice: 'Topping was successfully created.' }
        format.json { render :show, status: :created, location: @topping }
      else
        @toppings = Topping.all
        format.html { render :new, notice: 'Topping could not be saved.' }
        format.json { render json: @pizza.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def topping_params
      params.require(:topping).permit(:name)
    end

    def heroku_down
      render plain: "Application Error - the Heroku server (https://pizzaserver.herokuapp.com) is currently down. Please try again later.", status: 500
    end


end