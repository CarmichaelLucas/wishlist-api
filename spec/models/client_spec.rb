require 'rails_helper'

RSpec.describe Client, type: :model do

  it 'with success' do
    client = create(:client)

    expect(client).to be_valid
  end

  context 'Validate' do
    it 'name cannot be empty' do
      client = build(:client, name: nil)
      client.valid?
      
      expect(client.errors[:name]).to include('não pode ficar em branco')
    end

    it 'email not be empty' do
      client = build(:client, email: nil)
      client.valid?
      
      expect(client.errors[:email]).to include('não pode ficar em branco')
    end

    it 'email not be valid' do
      client = build(:client, email: "exemplo.invalido")
      client.valid?
      
      expect(client.errors[:email]).to include('não é válido')
    end
  end
end
