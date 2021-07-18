class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'H3Ll@W')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 'H3Ll@W', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_client
    if decoded_token
      client_id = decoded_token[0]['client_id']
      @client = Client.find_by(id: client_id)
    end
  end

  def logged_in?
    !!logged_in_client
  end

  def current_client_id
    decoded_token[0]['client_id']
  end

  def authorized
    render json: { message: 'Realize o login!' }, status: :unauthorized unless logged_in?
  end

  def forbidden
    render json: { message: 'Permissão negada para está ação!' }, status: :forbidden 
  end

  def resource_not_found
    render json: { message: 'Recurso não encontrado' }, status: :unprocessable_entity
  end

  def product_not_exists
    render json: { message: 'Produtos passados não existem ou invalidos' }, status: :unprocessable_entity
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
end
