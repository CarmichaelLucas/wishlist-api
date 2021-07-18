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
      let(:product) { build(:product) }

      it "creates a new Product" do
        expect {
          post '/products', params: { product: product }, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post '/products', params: { product: product }, as: :json
        
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters the of title" do
      let(:product) { build(:product, title: nil) }

      it "does not create a new Product" do
        expect {
          post '/products',
               params: { product: product }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Title não pode ficar em branco')
      end
    end

    context "with invalid parameters the of price" do
      let(:product) { build(:product, price: nil) }

      it "does not create a new Product" do
        expect {
          post '/products',
               params: { product: product }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Price não pode ficar em branco')
      end
    end
    
    context "with invalid parameters the of brand" do
      let(:product) { build(:product, brand: nil) }

      it "does not create a new Product" do
        expect {
          post '/products',
               params: { product: product }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Brand não pode ficar em branco')
      end
    end
  end

  describe "PATCH /update" do
    let(:new_product) { build(:product) }

    context "with valid parameters" do
      it "updates the requested product" do
        patch "/products/#{product.id}", params: { product: new_product }, as: :json

        product.reload
        expect(new_product.price).to eq(product.price)
        expect(new_product.brand).to eq(product.brand)
        expect(new_product.title).to eq(product.title)
      end

      it "renders a JSON response with the product" do
        patch "/products/#{product.id}", params: { product: new_product }, as: :json
        
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      let(:new_product) { build(:product, price: nil, brand: nil) }

      it "renders a JSON response with errors for the product" do
        patch "/products/#{product.id}", params: { product: new_product }, as: :json
        
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

  describe "POST /many" do 
    let(:products) { build_list(:product, 5) }

    it 'create collections the of products' do
      expect{  post '/many/products', params: { product_attributes: [ products ] }, as: :json }.to change(Product, :count).by(5)
    end

    context "with invalid parameters the of title" do
      let(:products) { build_list(:product, 2, title: nil) }

      it "does not create a new products" do
        expect {
          post '/many/products', params: { product_attributes: [ products ] }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Title não pode ficar em branco')
      end
    end

    context "with invalid parameters the of price" do
      let(:products) { build_list(:product, 2, price: nil) }

      it "does not create a new Product" do
        expect {
          post '/many/products', params: { product_attributes: [ products ] }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Price não pode ficar em branco')
      end
    end
    
    context "with invalid parameters the of brand" do
      let(:products) { build_list(:product, 2, brand: nil) }

      it "does not create a new Product" do
        expect {
          post '/many/products',
               params: { product_attributes: [ products ] }, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Brand não pode ficar em branco')
      end
    end
  end
end
