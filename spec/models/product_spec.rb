require 'rails_helper'

RSpec.describe Product, type: :model do
  
  it 'created with success' do
    product = create(:product)
    
    expect(product).to be_valid
  end

  context 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:brand) }
    it { is_expected.to validate_presence_of(:price) }
  end
end
