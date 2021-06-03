class ListsController < ApplicationController

  before_action :authorized
  before_action :set_client

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

    @list = List.new(client_id: @client.id, product_ids: params[:product_ids])

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT clients/1/lists/1
  def update
    return forbidden if current_client_id != @client.id

    @list = List.find_by(id: params[:id], client_id: params[:client_id])

    return resource_not_found if @list.nil?

    if @list.update(product_ids: params[:product_ids])
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
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
end
