require 'rails_helper'

RSpec.describe 'List', type: :request do

  let(:login) { post '/sign_in', params: { email: client.email }, as: :json }
  let(:valid_headers) { { Authorization: "Bearer #{json['token']}" } }
  let(:body) { { product_ids: products.map { |product| product.id } } }
  let(:client) { nil }
  let(:list) { create(:list, client: client) }
  let(:products) { [] }

  describe 'GET /index' do
    context 'with valid parameters' do
      let(:client) { create(:client) }
      before do 
        login
      end

      it 'renders a client data json' do
        get "/clients/#{list.client.id}/lists", headers: valid_headers, as: :json
        
        expect(json['list']['client']['id']).to eq(client.id)
        expect(json['list']['client']['name']).to eq(client.name)
        expect(json['list']['client']['email']).to eq(client.email)
      end

      it 'renders a successful response' do
        get "/clients/#{list.client.id}/lists", headers: valid_headers, as: :json

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do 
      let(:client) { create(:client) }
      let(:other_client) { create(:client) }
      it 'renders a forbidden response' do 
        login
        get "/clients/#{other_client.id}/lists", headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
      end

      it 'list not exist for the client' do
        login
        get "/clients/#{0}/lists", headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'client unauthorized' do
        get "/clients/#{list.client.id}/lists", as: :json
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /create' do

    context 'with parameters valid' do 
      let(:products) { create_list(:product, 3) }
      let(:client) { create(:client) }

      before do 
        login
      end

      it 'creates a new List' do      
        expect{
          post "/clients/#{client.id}/lists", params: body, headers: valid_headers, as: :json
        }.to change(List, :count).by(1)
      end

      it 'renders a created response' do
        post "/clients/#{client.id}/lists", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:created)
      end

      it 'validate return from a list' do
        post "/clients/#{client.id}/lists", params: body, headers: valid_headers, as: :json

        expect(json['list']['client']['id']).to eql(client.id)
        expect(json['list']['client']['name']).to eql(client.name)
        expect(json['list']['client']['email']).to eql(client.email)

        expect(json['list']['products'].length).to eql(products.size)
      end
    end

    context 'without parameters valid' do 
      let(:client) { create(:client) }
      let(:new_client) { create(:client) }
      let(:products) { create_list(:product, 1) }

      before do
        login
      end

      it 'create a list with client not exists' do
        post "/clients/#{0}/lists", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eql('Recurso não encontrado')
      end

      it 'create a list without products' do
        post "/clients/#{client.id}/lists", params: { product_ids: [] }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eql('Produtos passados não existem ou invalidos')
      end

      it 'create a list with product invalid' do
        post "/clients/#{client.id}/lists", params: { product_ids: ['@'] }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eql('Produtos passados não existem ou invalidos')
      end

      it 'create a list with product not exists' do
        post "/clients/#{client.id}/lists", params: { product_ids: [0, 999999] }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eql('Produtos passados não existem ou invalidos')
      end

      it 'try to create a list with client that exists' do
        post "/clients/#{list.client.id}/lists", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['client_id'][0]).to include('já está em uso')
      end

      it 'renders a response unauthorized' do 
        post "/clients/#{client.id}/lists", params: body, as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders a response forbidden' do
        
        post "/clients/#{new_client.id}/lists", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
      end

    end
  end

  describe 'PUT|PATCH /update' do 
    let(:client) { create(:client) }
    let(:products) { create_list(:product, 2) }

    before do
      login
    end

    context 'with parameters valid' do

      it 'renders a response success' do
        put "/clients/#{client.id}/lists/#{list.id}", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:success)
      end

      it 'validate return from a list' do
        put "/clients/#{client.id}/lists/#{list.id}", params: body, headers: valid_headers, as: :json

        expect(json['list']['client']['id']).to eql(client.id)
        expect(json['list']['client']['name']).to eql(client.name)
        expect(json['list']['client']['email']).to eql(client.email)
        expect(json['list']['products'].length).to eql(products.size)
      end
    end

    context 'without parameters valid' do
      let(:new_client) { create(:client) }

      it 'renders a response forbidden' do
        put "/clients/#{new_client.id}/lists/#{list.id}", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(json['message']).to eq("Permissão negada para está ação!")
      end

      it 'renders a response unauthorized' do
        put "/clients/#{client.id}/lists/#{list.id}", params: body, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(json['message']).to eq("Realize o login!")
      end

      it 'try to update a list without products' do
        put "/clients/#{client.id}/lists/#{list.id}", params: { product_ids: [] }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eq("Produtos passados não existem ou invalidos")
      end

      it 'try to update a list with products not exists' do
        put "/clients/#{client.id}/lists/#{list.id}", params: { product_ids: [] }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eq("Produtos passados não existem ou invalidos")
      end

      it 'try to update a list that not exist' do
        put "/clients/#{client.id}/lists/#{0}", params: body, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eq('Recurso não encontrado')
      end
    end
  end
  
  describe 'DELETE /destroy' do
    let(:client) { create(:client) }
    
    before do
      login
    end

    context 'with valid parameters' do
      it 'remove a list of the client' do
        delete "/clients/#{client.id}/lists/#{list.id}", headers: valid_headers, as: :json

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid parameters' do
      let(:other_client) { create(:client) }

      it 'try to remove a list of the client' do
        delete "/clients/#{client.id}/lists/#{list.id}", headers: valid_headers, as: :json

        expect(response).to have_http_status(:no_content)
      end

      it 'try to remove a list of another client' do
        delete "/clients/#{other_client.id}/lists/#{list.id}", headers: valid_headers, as: :json

        expect(response).to have_http_status(:forbidden)
      end

      it 'renders a response unauthorized' do
        delete "/clients/#{client.id}/lists/#{list.id}", as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
