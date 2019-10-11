# frozen_string_literal: true

FactoryBot.define do
  factory :testimonial do
    status  { 'ativo' }
    nome    { Faker::Name.name }
    email   { Faker::Internet.email }
    texto   { 'It is awesome!' }
    cidade  { 'Stars Hollow' }
    created { DateTime.current }
    association :institutional
  end
end
