class ListsController < ApplicationController

  before_action :authorized
  before_action :set_client
  before_action :set_product, only: [:create, :update]

  # GET client/1/lists
  def index
    return forbidden if current_client_id != @client.id

    @list = List.find_by(client_id: @client.id)
    return resource_not_found if @list.nil?

    render json: @list, include: [:products]
  end

  # POST client/1/lists
  def create
    return forbidden if current_client_id != @client.id

    @list = List.new(client_id: @client.id, product_ids: @product_ids)

    if @list.save
      render json: @list, status: :created, include: [:products]
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT clients/1/lists/1
  def update
    return forbidden if current_client_id != @client.id

    @list = List.find_by(id: params[:id], client_id: params[:client_id])
    
    return resource_not_found if @list.nil?

    render json: @list if @list.update(product_ids: @product_ids)
  end

  # DELETE client/1/lists/1
  def destroy
    return forbidden if current_client_id != @client.id

    @list = List.find_by(id: params[:id], client_id: params[:client_id])
    
    return resource_not_found if @list.nil?

    @list.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by(id: params[:client_id])

      return resource_not_found if @client.nil?

      @client
    end

    def set_product

      return product_not_exists if params[:product_ids].empty?

      params[:product_ids].each do |product_id|
        return product_not_exists unless product_id.instance_of?(Integer)
      end

      @products = Product.find_by_sql("SELECT * FROM products WHERE id in (\'#{params[:product_ids].join('\', \'')}\')")
      
      return product_not_exists if @products.empty?

      @product_ids = @products.map { | product | product.id } 
    end
end
