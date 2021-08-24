require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:product) { create(:product) }
  
  describe "GET /index" do
    it "renders a successful response" do 
      get '/products', as: :json
  
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get "/products/#{product.id}", as: :json

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:product) { attributes_for_list(:product, 1) }

      it "creates a new Product" do
        post '/products', params: { product_attributes: product }, as: :json
        
        expect(json['products'][0]['title']).to eq(product.first[:title])
        expect(json['products'][0]['brand']).to eq(product.first[:brand])
        expect(json['products'][0]['price']).to eq(product.first[:price])
        expect(json['products'][0]['image']).to eq(product.first[:image])
        expect(json['products'][0]['review_score']).to eq(product.first[:review_score])
      end

      it "renders a JSON response with the new product" do
        post '/products', params: { product_attributes: product }, as: :json
        
        expect(response).to have_http_status(:created)  
      end
    end

    context 'with a list the products' do
      let(:product) { attributes_for_list(:product, 2) }

      it 'create collections' do
        post '/products', params: { product_attributes: product }, as: :json

        expect(json['products'][0]['title']).to eq(product.first[:title])
        expect(json['products'][0]['brand']).to eq(product.first[:brand])
        expect(json['products'][0]['price']).to eq(product.first[:price])
        expect(json['products'][0]['image']).to eq(product.first[:image])
        expect(json['products'][0]['review_score']).to eq(product.first[:review_score])

        expect(json['products'][1]['title']).to eq(product.last[:title])
        expect(json['products'][1]['brand']).to eq(product.last[:brand])
        expect(json['products'][1]['price']).to eq(product.last[:price])
        expect(json['products'][1]['image']).to eq(product.last[:image])
        expect(json['products'][1]['review_score']).to eq(product.last[:review_score])
      end
    end
  end

  describe "PUT|PATCH /update" do
    let(:new_product) { attributes_for(:product, image: 'https://exemplo.io/image.png') }

    context "with valid parameters" do
      it "updates the requested product" do
        put "/products/#{product.id}", params: new_product, as: :json

        expect(json["product"]["id"]).to eq(product.id)
        expect(json["product"]["price"].to_f).to eq(new_product[:price].to_f)
        expect(json["product"]["image"]).to eq(new_product[:image])
        expect(json["product"]["brand"]).to eq(new_product[:brand])
        expect(json["product"]["title"]).to eq(new_product[:title])
      end

      it "renders a JSON response with the product" do
        put "/products/#{product.id}", params: new_product, as: :json
        
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      let(:new_product) { attributes_for(:product, price: nil, brand: nil) }

      it "renders a JSON response with errors for the product" do
        put "/products/#{product.id}", params: new_product, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product
      expect {
        delete "/products/#{product.id}", as: :json
      }.to change(Product, :count).by(-1)
    end
  end
end
