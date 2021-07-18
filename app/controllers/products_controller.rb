class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    lister = ProductManager::Lister.new(params)
    @products = lister.build
    render json: @products, meta: pagination_dict(@products)
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = ProductManager::Creator.new(product_params)
    @product.execute_creating!

    render json: @product, status: :created
  end

  # POST /many/products
  def many
    params.permit!
    @products = ProductManager::Creator.new(params[:product_attributes])
    @products.execute_creating!
      
    render json: @products, status: :created 
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:price, :image, :brand, :title, :review_score)
    end
end
