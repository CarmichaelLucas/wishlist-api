require 'rails_helper'

RSpec.describe AWSManager::AWS do
  let(:aws) { described_class.new }
  
  it { expect(aws.credentials).to be_kind_of(Hash) }
  it { expect(aws.credentials).to include(
                                          :access_key_id,
                                          :secret_access_key,
                                          :region
  ) }
end