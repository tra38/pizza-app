class PizzasController < ApplicationController
  before_action :set_pizza, only: [:show, :edit, :update, :destroy]
  rescue_from HttpRequest::InvalidResponse, with: :heroku_down

  # GET /pizzas
  # GET /pizzas.json
  def index
    @new_pizza = Pizza.new
    @pizzas = Pizza.all.paginate(:page => params[:page])
    @toppings = Topping.all
    @new_topping = Topping.new
  end

  # GET /pizzas/1
  # GET /pizzas/1.json
  def show
    id = params[:id].to_i
    @pizza = Pizza.find(id)
    @toppings = Topping.all
  end

  # GET /pizzas/new
  def new
    @pizza = Pizza.new
  end

  # GET /pizzas/1/edit
  def edit
  end

  # POST /pizzas
  # POST /pizzas.json
  def create
    @pizza = Pizza.new(pizza_params)

    respond_to do |format|
      if @pizza.save
        format.html { redirect_to "/", notice: 'Pizza was successfully created.' }
        format.json { render :show, status: :created, location: @pizza }
      else
        @toppings = Topping.all
        format.html { render :new }
        format.json { render json: @pizza.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pizzas/1
  # PATCH/PUT /pizzas/1.json
  def update
    respond_to do |format|
      if @pizza.update(pizza_params)
        format.html { redirect_to "/", notice: 'Pizza was successfully updated.' }
        format.json { render :show, status: :ok, location: @pizza }
      else
        @toppings = Topping.all
        format.html { render :edit }
        format.json { render json: @pizza.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pizzas/1
  # DELETE /pizzas/1.json
  def destroy
    @pizza.destroy
    respond_to do |format|
      format.html { redirect_to pizzas_url, notice: 'Pizza was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pizza
      @pizza = Pizza.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pizza_params
      params.require(:pizza).permit(:id, :name, :description, topping_ids: [])
    end

    def heroku_down
      render plain: "Application Error - the Heroku server (https://pizzaserver.herokuapp.com) is currently down. Please try again later.", status: 500
    end

end
