require 'faker'

FactoryBot.define do
  factory :client do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end