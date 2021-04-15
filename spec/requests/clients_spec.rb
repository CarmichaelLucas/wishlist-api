require 'rails_helper'

RSpec.describe "/clients", type: :request do
  
  let(:client) { create(:client) }
  let(:login) {
    post '/sign_in', params: { email: client.email }, as: :json
  }
  let(:valid_headers) {
    { Authorization: "Bearer #{json['token']}" }
  }
  
  describe "GET /index" do
    it 'renders a successful response' do 
      get '/clients', as: :json

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    context 'with valid token' do
      it 'renders a successful response' do 
        login
        client
  
        get "/clients/#{client.id}", headers: valid_headers, as: :json
  
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid token' do 
      let(:new_client) { create(:client) }
      it 'renders a forbidden response' do
        login
        new_client
  
        get "/clients/#{new_client.id}", headers: valid_headers, as: :json
  
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /create" do
    
    context 'with valid parameters' do
      let(:client) { build(:client) }  
      it 'creates a new Client' do      
        expect{
          post '/clients', params: { client: client }, as: :json
        }.to change(Client, :count).by(1)
      end

      it 'renders a JSON response with the new' do
        post '/clients', params: { client: client }, as: :json

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json")
      end

      it 'returns the Token response body' do
        post '/clients', params: { client: client }, as: :json
  
        expect(json["token"]).not_to be_empty
      end
    end

    context 'with invalid parameters' do
      let(:client_without_name) { build(:client, name: nil) }
      let(:client_without_email) { build(:client, email: nil) }
      let(:client_invalid_email) { build(:client, email: 'teste.teste.com') }

      it 'name is nill' do
        post '/clients', params: { client: client_without_name }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["name"][0]).to eq('não pode ficar em branco')
      end  
      
      it 'email is nill' do
        post '/clients', params: { client: client_without_email }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["email"]).to include('não pode ficar em branco')
      end

      it 'email is invalid' do
        post '/clients', params: { client: client_invalid_email }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["email"]).to include('não é válido')
      end

      it 'email in use' do
        client
        post '/clients', params: { client: client }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["email"][0]).to eq('já está em uso')
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_client) { build(:client) }
      it "updates the requested client" do
        login
        client
        
        patch "/clients/#{client.id}", params: { client: new_client }, headers: valid_headers, as: :json

        client.reload
        expect(new_client.name).to eq(client.name)
        expect(new_client.email).to eq(client.email)
      end

      it "renders a JSON response with the client" do
        login
        client
        
        patch "/clients/#{client.id}", params: { client: new_client }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid parameters" do
      let(:new_client) { build(:client, name: nil, email: nil) }

      it "renders a JSON response with errors for the client" do
        login
        client
 
        patch "/clients/#{client.id}", params: { client: new_client }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end

      let(:new_client) { create(:client) }
      it 'renders a JSON response forbidden' do
        login
        new_client

        patch "/clients/#{new_client.id}", params: { client: new_client }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /destroy" do
    context 'with valid parameters' do
      it 'destroys the requested client' do
        login
        client
  
        expect {
          delete "/clients/#{client.id}", headers: valid_headers, as: :json
        }.to change(Client, :count).by(-1)
      end

      it 'renders a JSON response by removing client' do
        login
        client
  
        delete "/clients/#{client.id}", headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid parameters' do
      let(:other_client) { create(:client) }
      it 'does not destroy the requested customer' do
        login
        client

        delete "/clients/#{other_client.id}", headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end