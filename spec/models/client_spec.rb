require 'rails_helper'

RSpec.describe Client, type: :model do

  it 'with success' do
    client = create(:client)

    expect(client).to be_valid
  end

  context 'Validate' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end
end
