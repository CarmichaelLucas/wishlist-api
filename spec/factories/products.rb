require 'faker'

FactoryBot.define do
  factory :product do
    price { Faker::Commerce.price }
    image { "https://aws.s3.com/product/image.jpeg" }
    brand { Faker::Commerce.material }
    title { Faker::Commerce.product_name }
    review_score { nil }
  end

  factory :product_params, class: Hash do
    price { Faker::Commerce.price }
    image { "https://aws.s3.com/product/image.jpeg" }
    brand { Faker::Commerce.material }
    title { Faker::Commerce.product_name }
    review_score { nil }
    
    initialize_with { attributes } 
  end
end
