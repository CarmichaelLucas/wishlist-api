require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { create(:client) }
  
  it { expect(client).to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
end
