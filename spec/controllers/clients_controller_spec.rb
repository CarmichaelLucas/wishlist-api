require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  describe "POST /client" do
    let(:client_params) { attributes_for(:client) }

    it '#create with sucess' do      
      expect{
        post :create, params: { client: client_params }
      }.to change(Client, :count).by(1)
    end

    context 'validate' do
      it 'returns a 201 response' do
        post :create, params: { client: client_params }

        expect(response.status).to eq(201)
      end

      it 'returns a message Created in response' do
        post :create, params: { client: client_params }
        
        expect(response.message).to include('Created')
      end

      it 'returns the Token response body' do
        post :create, params: { client: client_params }
  
        expect(JSON.parse(response.body)["token"]).not_to be_empty
      end
    end

  end


end
