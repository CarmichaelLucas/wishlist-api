require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) { create(:favorite) }

  it { expect(favorite).to be_valid }
  it { is_expected.to validate_uniqueness_of(:product_id).scoped_to(:list_id) }
end
