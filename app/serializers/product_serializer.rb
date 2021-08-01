class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :brand, :price, :image, :review_score
end
