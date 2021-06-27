class ListSerializer < ActiveModel::Serializer
  attributes :id, :client

  belongs_to :client
  has_many :products

  def client
    client = object.client
    
    { 
      id: client.id,
      name: client.name,
      email: client.email
    }
  end
end
