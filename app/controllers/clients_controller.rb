class ClientsController < ApplicationController

  before_action :authorized, except: [:sign_in, :create, :index]

  before_action :set_client, only: [:show, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all

    render json: @clients
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
      render json: {error: "E-mail Invalido!"}, status: :unauthorized
    end
  end

  # GET /auth_token
  def auth_token
    render json: @client
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.require(:client).permit(:name, :email)
    end
end
