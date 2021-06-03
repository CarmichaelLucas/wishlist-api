class ListSerializer < ActiveModel::Serializer
  attributes :id, :client

  belongs_to :client
  has_many :products

  def client
    ActiveModel::ClientSerializer.new(object.client)
  end
end
