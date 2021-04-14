require 'rails_helper'

RSpec.describe "/products", type: :request do
 
  let(:product) { create(:product) }
  let(:client) { create(:client) }
  let(:login) {
    post '/sign_in', params: { email: client.email }, as: :json
  }
  let(:valid_headers) {
    { Authorization: "Bearer #{json['token']}" }
  }
  
  describe "GET /index" do
    it "renders a successful response" do 
      get '/products', as: :json
  
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      login
      get "/products/#{product.id}", headers: valid_headers, as: :json
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    
    context "with valid parameters" do
      let(:product) { build(:product) }

      it "creates a new Product" do
        login
        
        expect {
          post '/products',
               params: { product: product }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        login
        post '/products',
             params: { product: product }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid parameters" do
      let(:product) { build(:product, price: nil, brand: nil) }
      
      it "does not create a new Product" do
        login

        expect {
          post '/products',
               params: { product: product }, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with errors for the new product" do
        login
        post '/products',
             params: { product: product }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "PATCH /update" do
    let(:new_product) { build(:product) }

    context "with valid parameters" do
      it "updates the requested product" do
        login
        product
        
        patch "/products/#{product.id}", params: { product: new_product }, headers: valid_headers, as: :json

        product.reload
        expect(new_product.price).to eq(product.price)
        expect(new_product.brand).to eq(product.brand)
        expect(new_product.title).to eq(product.title)
      end

      it "renders a JSON response with the product" do
        login
        product

        patch "/products/#{product.id}",
              params: { product: new_product }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:new_product) { build(:product, price: nil, brand: nil) }

      it "renders a JSON response with errors for the product" do
        login
        product
 
        patch "/products/#{product.id}",
              params: { product: new_product }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      login
      product
      
      expect {
        delete "/products/#{product.id}", headers: valid_headers, as: :json
      }.to change(Product, :count).by(-1)
    end
  end
end