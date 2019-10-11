# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    nome        { 'Michael Scott' }
    email       { |_n| Faker::Internet.email }
    password    { Faker::Lorem.characters(10) }
    usuario     { |_n| Faker::Lorem.characters(10) }
    senha       { Faker::Lorem.characters(10) }
    association :admin_type
  end
end
