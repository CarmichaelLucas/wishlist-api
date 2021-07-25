require 'rails_helper'

RSpec.describe ProductManager::Lister do

  subject(:lister) { described_class.new(params) }
  let!(:products) { nil }
  let(:filter) { lister.filter('Product') }
  let(:price_initial) { nil }
  let(:price_final) { nil }
  let(:brand) { nil }
  let(:title) { nil }
  let(:page) { nil }
  let(:per_page) { nil }
  let(:params) do
    {
      title: title,
      brand: brand,
      price_initial: price_initial,
      price_final: price_final,
      page: page,
      per_page: per_page
    }
  end

  describe '#build' do
    let!(:products) { create(:product) }


    it { is_expected.to respond_to(:build) }
    it { expect(lister.build.name).to eq('Product') }
    it { expect(lister.build.first.class).to eq(Product) }
  end

  describe '#query' do

    it { is_expected.to respond_to(:query) }

    context 'attributes in methods' do 
      it { expect(lister.query).to include(:title_cont) } 
      it { expect(lister.query).to include(:brand_cont) } 
      it { expect(lister.query).to include(:price_gteq) } 
      it { expect(lister.query).to include(:price_lteq) } 
      it { expect(lister.query).to include(:s) }
    end 

    context 'return values in the attributes' do
      
      let(:price_initial) { 9.99 }
      let(:price_final) { 103.53 }
      let(:brand) { 'Teste Brand' }
      let(:title) { 'Teste Title' }

      it { expect(lister.query).to include({ 
                                            :title_cont => title,
                                            :brand_cont => brand, 
                                            :price_gteq => price_initial,
                                            :price_lteq => price_final, 
                                            :s => 'id desc'}) }
    end
  end

  describe '#filter' do
    let!(:products) { create_list(:product, 25) }

    it { is_expected.to respond_to(:filter) }

    context 'return list with ransack configuration' do 

      it { expect(filter.page.size).to eq(10)  }
      it { expect(filter.next_page).to eq(2) }
      it { expect(filter.prev_page).to eq(nil) }
      it { expect(filter.first).to be_valid }
      
    end 

    context 'next page the of list products' do
    
      let(:page) { 2 }
      let(:per_page) { 5 }
                
      it { expect(filter.prev_page).to eq(1) } 
      it { expect(filter.next_page).to eq(3) }
      it { expect(filter.size).to eq(5) } 
    end

    context 'return response the list product' do
      let(:product) { Product.last }
      let(:title) { product.title }
      let(:brand) { product.brand }
      let(:price_initial) { product.price }
      let(:price_final) { product.price }
      
      it { expect(filter.size).to eq(1) }
      it { expect(filter.first.id).to eq(product.id) }
      it { expect(filter.first.title).to eq(product.title) }
      it { expect(filter.first.brand).to eq(product.brand) }
      it { expect(filter.first.price.to_f).to eq(product.price.to_f) }
    end
  end
end
