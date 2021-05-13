class List < ApplicationRecord
  belongs_to :client

  has_many :favorites
  has_many :products, :through => :favorites

  accepts_nested_attributes_for :products, allow_destroy: true

  validates_uniqueness_of :client_id
end
