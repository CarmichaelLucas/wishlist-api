class Favorite < ApplicationRecord
  belongs_to :list
  belongs_to :product

  validates_uniqueness_of :product_id, :scope => :list_id
end
