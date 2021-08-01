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
      let(:product) { attributes_for(:product) }

      it "creates a new Product" do
        expect {
          post '/products', params: { product_attributes: product }, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post '/products', params: { product_attributes: product }, as: :json
        
        expect(response).to have_http_status(:created)
      end
    end

    context 'with a list the products' do
      let(:product) { attributes_for_list(:product, 5) }

      it 'create collections' do
        expect{  post '/products', params: { product_attributes: product }, as: :json }.to change(Product, :count).by(5)
      end
    end

    context "with invalid parameters the of title" do
      let(:product) { attributes_for(:product, title: nil) }

      it "does not create a new Product" do
        expect {
          post '/products',
               params: { product_attributes: product }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, /Title não pode ficar em branco/)
      end
    end

    context "with invalid parameters the of price" do
      let(:product) { attributes_for(:product, price: nil) }

      it "does not create a new Product" do
        expect {
          post '/products', params: { product_attributes: product }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, /Price não pode ficar em branco/)
      end
    end
    
    context "with invalid parameters the of brand" do
      let(:product) { attributes_for(:product, brand: nil) }

      it "does not create a new Product" do
        expect {
          post '/products',
               params: { product: { product_attributes: product } }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, /Brand não pode ficar em branco/)
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
