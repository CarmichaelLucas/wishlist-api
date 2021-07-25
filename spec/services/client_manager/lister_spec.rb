require 'rails_helper'

RSpec.describe ClientManager::Lister do

  subject(:lister) { described_class.new(params) }
  let!(:clients) { nil }
  let(:filter) { lister.filter('Client') }
  let(:name) { nil }
  let(:email) { nil }
  let(:page) { nil }
  let(:per_page) { nil }
  let(:params) do
    {
      name: name,
      email: email,
      page: page,
      per_page: per_page
    }
  end

  describe '#build' do
    let!(:clients) { create(:client) }


    it { is_expected.to respond_to(:build) }
    it { expect(lister.build.name).to eq('Client') }
    it { expect(lister.build.first.class).to eq(Client) }
  end

  describe '#query' do

    it { is_expected.to respond_to(:query) }

    context 'attributes in methods' do 
      it { expect(lister.query).to include(:name_cont) } 
      it { expect(lister.query).to include(:email_eq) } 
      it { expect(lister.query).to include(:s) }
    end 

    context 'return values in the attributes' do
      let(:name) { 'John' }
      let(:email) { 'doe@example.com' }

      it { expect(lister.query).to include({:name_cont => name, :email_eq => email, :s => 'id desc'}) }
    end
  end

  describe '#filter' do
    let!(:clients) { create_list(:client, 25) }

    it { is_expected.to respond_to(:filter) }

    context 'return list with ransack configuration' do 

      it { expect(filter.page.size).to eq(10)  }
      it { expect(filter.next_page).to eq(2) }
      it { expect(filter.prev_page).to eq(nil) }
      it { expect(filter.first).to be_valid }
      
    end 

    context 'next page the of list clients' do
    
      let(:page) { 2 }
      let(:per_page) { 5 }
                
      it { expect(filter.prev_page).to eq(1) } 
      it { expect(filter.next_page).to eq(3) }
      it { expect(filter.size).to eq(5) } 
    end

    context 'return response the list client' do
      let(:client) { Client.last }
      let(:email) { client.email }
      
      it { expect(filter.size).to eq(1) }
      it { expect(filter.first.id).to eq(client.id) }
      it { expect(filter.first.name).to eq(client.name) }
      it { expect(filter.first.email).to eq(client.email) }
    end
  end
end
