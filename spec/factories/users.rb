# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nome     { 'Ross Geller' }
    email    { |_n| Faker::Internet.email }
    password { Faker::Lorem.characters(10) }
  end
end
