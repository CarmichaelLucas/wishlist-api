require 'rails_helper'

RSpec.describe List, type: :model do
  let(:list) { create(:list) }

  it { expect(list).to be_valid }
  it { is_expected.to validate_uniqueness_of(:client_id) }
end
