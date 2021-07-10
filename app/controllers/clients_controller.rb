require_relative '../services/client/lister.rb/'

class ClientsController < ApplicationController

  before_action :authorized, except: [:sign_in, :create, :index]
  before_action :set_client, only: [:show, :update, :destroy]
  before_action :access_resource, only: [:show, :update, :destroy]
    
  # GET /clients
  def index
    lister = Lister.new(name: params[:name], email: params[:email], page: params[:page], per_page: params[:per_page])
    @clients = lister.filter
    render json: @clients, meta: pagination_dict(@clients)
  end

  # GET /clients/1
  def show
    render json: @client
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      token = encode_token({ client_id: @client.id, email: @client.email })
      render json: { client: @client, token: token }, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
  end

  # POST /sign_in 
  def sign_in
    @client = Client.find_by(email: params[:email])

    if @client
      token = encode_token({ client_id: @client.id, email: @client.email})
      render json: { client: @client, token: token }
    else
      render json: { message: "Informação invalida, tente novamente" }, status: :unauthorized
    end
  end

  # GET /auth_token
  def auth_token
    render json: @client
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = client
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.require(:client).permit(:name, :email)
    end

    def pagination_dict(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end

    def access_resource
      return forbidden if current_client_id != client.id
    end

    def client
      return resource_not_found if Client.find_by(id: params[:id]).nil?

      Client.find_by(id: params[:id])
    end
end
