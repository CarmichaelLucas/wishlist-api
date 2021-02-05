class ApplicationController < ActionController::API
  before_action :authorized

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

  def authorized
    render json: { message: 'Realize o Login!' }, status: :unauthorized unless logged_in?
  end
end
