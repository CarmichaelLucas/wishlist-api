class ClientsController < ApplicationController

  before_action :authorized, except: [:sign_in, :create, :index]
  before_action :set_client, only: [:show, :update, :destroy]
  before_action :access_resource, only: [:show, :update, :destroy]
    
  # GET /clients
  def index
    lister = Client.all.page(params[:page]).per(params[:per_page])
    @clients = lister.ransack(filters).result
    
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
      ClientWorker.perform_in(1.minute, @client.id)
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
    def set_client
      @client = client
    end

    def client_params
      params.require(:client).permit(:name, :email)
    end


    def access_resource
      return forbidden if current_client_id != client.id
    end

    def client
      return resource_not_found if Client.find_by(id: params[:id]).nil?

      Client.find_by(id: params[:id])
    end

    def filters
      {
        name_cont: params[:name],
        email_eq: params[:email],
        s: 'id desc' 
      }
    end
end
