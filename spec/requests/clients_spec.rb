require 'rails_helper'

RSpec.describe "/clients", type: :request do
  
  let(:client) { nil }
  let(:login) {
    post '/sign_in', params: { email: client.email }, as: :json
  }
  let(:valid_headers) {
    { Authorization: "Bearer #{json['token']}" }
  }
  
  describe "GET /index" do
    it 'renders a successful response' do 
      get '/clients', as: :json

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let(:client) { create(:client) }

    before do 
      login
    end

    context 'with valid token' do
      it 'renders a response success' do 
        get "/clients/#{client.id}", headers: valid_headers, as: :json
  
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid token' do 
      let(:new_client) { create(:client) }
      it 'renders a response forbidden' do
        get "/clients/#{new_client.id}", headers: valid_headers, as: :json
  
        expect(response).to have_http_status(:forbidden)
      end

      it 'renders a response unauthorized' do
        get "/clients/#{new_client.id}", as: :json
  
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    let(:client) { build(:client) } 

    context 'with valid parameters' do
      it 'creates a new Client' do      
        expect{
          post '/clients', params: { client: client }, as: :json
        }.to change(Client, :count).by(1)
      end

      it 'renders a response with the new client' do
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
        client.save
        post '/clients', params: { client: client }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["email"][0]).to eq('já está em uso')
      end

    end
  end

  describe "PUT|PATCH /update" do
    let(:client) { create(:client) }

    before do
      login
    end

    context "with valid parameters" do
      let(:new_client) { build(:client) }

      it "updates the requested client" do  
        put "/clients/#{client.id}", params: { client: new_client }, headers: valid_headers, as: :json

        client.reload
        expect(new_client.name).to eq(client.name)
        expect(new_client.email).to eq(client.email)
      end

      it "renders a JSON response with the client" do 
        put "/clients/#{client.id}", params: { client: new_client }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'with invalid parameters' do

      let(:client_name_invalid) { build(:client, name: nil) }
      let(:client_email_invalid) { build(:client, email: nil) }
      let(:new_client) { create(:client) }
      
      it 'renders a response unprocessable_entity' do
        put "/clients/#{client.id}", params: { client: client_name_invalid }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end

      it 'try to update the client with name invalid' do
        put "/clients/#{client.id}", params: { client: client_name_invalid }, headers: valid_headers, as: :json
        
        expect(json['name']).to include('não pode ficar em branco')
      end

      it 'try to update the client with email invalid' do
        put "/clients/#{client.id}", params: { client: client_email_invalid }, headers: valid_headers, as: :json
    
        expect(json['email']).to include('não pode ficar em branco')
      end
      
      it 'renders a response forbidden' do
        put "/clients/#{new_client.id}", params: { client: new_client }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:forbidden)
      end

      it 'renders a response unauthorized' do
        put "/clients/#{new_client.id}", params: { client: new_client }, as: :json
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:client) { create(:client) }
    before do
      login
    end

    context 'with valid parameters' do
      it 'destroys the requested client' do
        expect {
          delete "/clients/#{client.id}", headers: valid_headers, as: :json
        }.to change(Client, :count).by(-1)
      end

      it 'renders a JSON response by removing client' do
        delete "/clients/#{client.id}", headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid parameters' do
      let(:another_client) { create(:client) }
      it 'renders a response forbidden' do
        delete "/clients/#{another_client.id}", headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
      end

      it 'renders a response unauthorized' do
        delete "/clients/#{another_client.id}", as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /sign_in" do
    context 'with params valid' do
      let(:client) { create(:client) }
      it 'renders a response success' do
        login

        expect(response).to have_http_status(:success)
      end

      it 'returns the Token response body' do
        login
        
        expect(json['token']).not_to be_empty 
      end

      it 'returns the client response body' do
        login
        
        expect(json['client']['id']).to eq(client.id)
        expect(json['client']['name']).to eq(client.name)
        expect(json['client']['email']).to eq(client.email)
      end
    end

    context 'without params valid' do
      let(:client) { build(:client, email: 'not@exist.com') }
      it 'renders a response unauthorized' do
        login

        expect(response).to have_http_status(:unauthorized)
        expect(json['message']).to eq('Informação invalida, tente novamente')
      end
    end
  end

  describe "GET /auth_token" do
    context 'with params valid' do
      let(:client) { create(:client) }
      
      before do
        login
      end

      it 'renders a response success' do
        get '/auth_token', headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:success)
      end 

      it 'returns the client response body' do
        get '/auth_token', headers: valid_headers, as: :json

        expect(json['client']['id']).to eq(client.id)
        expect(json['client']['name']).to eq(client.name)
        expect(json['client']['email']).to eq(client.email)
      end
    end

    context 'without params valid' do
      
      it 'renders a response unauthorized' do
        get '/auth_token', headers: { Authorization: "hash_invalid" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(json['message']).to eq("Realize o Login!")
      end
      
    end
  end
end