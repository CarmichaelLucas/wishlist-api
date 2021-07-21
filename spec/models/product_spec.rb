require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }  

  it { expect(product).to be_valid }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:brand) }
  it { is_expected.to validate_presence_of(:price) }
end
