class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :image, :brand, :title, :review_score, :created_at, :updated_at
end
