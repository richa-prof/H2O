# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    nome        { Faker::Name.name }
    contratado  { '2018-07-17' }
    imagem      { 'test_imagem_1.png' }
    association :institutional
  end
end
