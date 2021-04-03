class Product < ApplicationRecord

  validates :price, :title, :brand, presence: true
end
