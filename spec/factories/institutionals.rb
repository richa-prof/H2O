# frozen_string_literal: true

FactoryBot.define do
  factory :institutional do
    tag               { 'fresh_prince' }
    titulo            { Faker::TheFreshPrinceOfBelAir.celebrity }
    titulo_menu       { Faker::TheFreshPrinceOfBelAir.character }
    texto             { Faker::TheFreshPrinceOfBelAir.quote }
    metatag_titulo    { Faker::TheFreshPrinceOfBelAir.celebrity }
    metatag_descricao { Faker::TheFreshPrinceOfBelAir.quote }
    exibir_menu       { true }

    trait :with_pt_br_locale do
      after(:create) do |institutional|
        create(:institutional_locale, :pt_br, institutional: institutional)
      end
    end
  end
end
