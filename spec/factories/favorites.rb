FactoryBot.define do
  factory :favorite do
    list factory: :list
    product factory: :product
  end
end
