require 'faker'
FactoryBot.define do
  factory :item do
    name { Faker::Books::Lovecraft.deity }
    done { false }
    todo
  end
end
