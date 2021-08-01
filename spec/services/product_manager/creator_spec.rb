require 'rails_helper'

RSpec.describe ProductManager::Creator do
  let(:product) { nil }
  subject(:object) { described_class.new(product).execute_creating! }

  describe '#execute_creating!' do
    context 'create the of product' do
      let(:product) { attributes_for(:product, review_score: 1.34) }

      it{ expect(object.class).to eq(Product) }
      it{ expect(object).to be_valid }
      it{ expect(object.title).to eq(product[:title]) }
      it{ expect(object.brand).to eq(product[:brand]) }
      it{ expect(object.price.to_f).to eq(product[:price].to_f) }
      it{ expect(object.image).to eq(product[:image]) }
      it{ expect(object.review_score).to eq(product[:review_score]) }
    end

    context 'create list the of product' do
      let(:product) { attributes_for_list(:product, 2) }
      
      it{ expect(object.class).to eq(Array) }
      it{ expect(object.first.class).to eq(Product) }
      it{ expect(object.last.class).to eq(Product) }
      it{ expect(object.first).to be_valid }
      it{ expect(object.last).to be_valid }
      it{ expect(object.count).to eq(2) }

      it{ expect(object.first.title).to eq(product[0][:title]) }
      it{ expect(object.first.brand).to eq(product[0][:brand]) }
      it{ expect(object.first.price.to_f).to eq(product[0][:price].to_f) }
      it{ expect(object.first.image).to eq(product[0][:image]) }
      it{ expect(object.first.review_score).to eq(product[0][:review_score]) }

      it{ expect(object.last.title).to eq(product[1][:title]) }
      it{ expect(object.last.brand).to eq(product[1][:brand]) }
      it{ expect(object.last.price.to_f).to eq(product[1][:price].to_f) }
      it{ expect(object.last.image).to eq(product[1][:image]) }
      it{ expect(object.last.review_score).to eq(product[1][:review_score]) }
    end

    context 'returns exception Products without title' do
      let(:product) { attributes_for(:product, title: nil) }
      
      it{ expect{ object }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Title não pode ficar em branco') }  
    end

    context 'returns exception Products without brand' do
      let(:product) { attributes_for(:product, brand: nil) }
      
      it{ expect{ object }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Brand não pode ficar em branco') }  
    end
    
    context 'returns exception Products without price' do
      let(:product) { attributes_for(:product, price: nil) }
      
      it{ expect{ object }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Price não pode ficar em branco') }  
    end
  end
  
end
