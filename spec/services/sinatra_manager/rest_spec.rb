require 'rails_helper'


RSpec.describe SinatraManager::Rest do
  let(:uri) { "http://sinatra:4567/test" }  
  let(:payload) { "ok" }
  let(:response) { described_class.new.get_test }

  it 'does return success' do  
    stub_request(:get, uri).to_return(body: payload, status: 200)
    
    expect(response.code).to eq('200')
    expect(response.body).to eq('ok')
  end

  it 'does not return success' do 
    stub_request(:get, uri).to_return(status: [500, "Internal Server Error"])
    
    expect{ response }.to raise_error(Net::HTTPFatalError)
  end
end
