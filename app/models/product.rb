class Product < ApplicationRecord
  has_many :favorites
  has_many :lists, :through => :favorites

  validates :price, :title, :brand, presence: true
end
