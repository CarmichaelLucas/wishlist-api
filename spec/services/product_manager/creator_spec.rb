require 'rails_helper'

RSpec.describe ProductManager::Creator do
  let(:product) { nil }
  subject(:create_product) { described_class.new.execute_creating!(product) }
  subject(:create_job) { described_class.new.execute_jobs(product) }
  
  describe '#execute_creating!' do
    context 'create the of product' do
      let(:product) { attributes_for(:product, review_score: 1.34) }

      it{ expect(create_product.class).to eq(Product) }
      it{ expect(create_product).to be_valid }
      it{ expect(create_product.title).to eq(product[:title]) }
      it{ expect(create_product.brand).to eq(product[:brand]) }
      it{ expect(create_product.price.to_f).to eq(product[:price].to_f) }
      it{ expect(create_product.image).to eq(product[:image]) }
      it{ expect(create_product.review_score).to eq(product[:review_score]) }
    end

    context 'create list the of product' do
      let(:product) { attributes_for_list(:product, 2) }
      
      it{ expect(create_product.class).to eq(Array) }
      it{ expect(create_product.first.class).to eq(Product) }
      it{ expect(create_product.last.class).to eq(Product) }
      it{ expect(create_product.first).to be_valid }
      it{ expect(create_product.last).to be_valid }
      it{ expect(create_product.count).to eq(2) }

      it{ expect(create_product.first.title).to eq(product[0][:title]) }
      it{ expect(create_product.first.brand).to eq(product[0][:brand]) }
      it{ expect(create_product.first.price.to_f).to eq(product[0][:price].to_f) }
      it{ expect(create_product.first.image).to eq(product[0][:image]) }
      it{ expect(create_product.first.review_score).to eq(product[0][:review_score]) }

      it{ expect(create_product.last.title).to eq(product[1][:title]) }
      it{ expect(create_product.last.brand).to eq(product[1][:brand]) }
      it{ expect(create_product.last.price.to_f).to eq(product[1][:price].to_f) }
      it{ expect(create_product.last.image).to eq(product[1][:image]) }
      it{ expect(create_product.last.review_score).to eq(product[1][:review_score]) }
    end

    context 'returns exception Products without title' do
      let(:product) { attributes_for(:product, title: nil) }
      
      it{ expect{ create_product }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Title não pode ficar em branco') }  
    end

    context 'returns exception Products without brand' do
      let(:product) { attributes_for(:product, brand: nil) }
      
      it{ expect{ create_product }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Brand não pode ficar em branco') }  
    end
    
    context 'returns exception Products without price' do
      let(:product) { attributes_for(:product, price: nil) }
      
      it{ expect{ create_product }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Price não pode ficar em branco') }  
    end
  end
  
  describe '#execute_jobs' do
    context 'create new product' do
      let(:product) { attributes_for_list(:product, 1) }
      
      it { expect(create_job).to eq(product) }
    end

    context 'list create news products' do
      let(:product) { attributes_for_list(:product, 2) }
      
      it { expect(create_job).to eq(product) }
    end
  end
end
