# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    passeio_data           { Date.current + 3.days }
    passeio_hora           { '13:00' }
    preco_total            { 90 }
    qtde_adulto            { 3 }
    qtde_crianca           { 2 }
    qtde_crianca2          { 1 }
    qtde                   { 6 }
    preco_adulto           { 20 }
    preco_crianca          { 12 }
    preco_crianca2         { 6 }
    reserva                { nil }
    preco_unitario         { 0 }
    produto_variacao_id    { 1 }
    produto_subvariacao_id { 1 }
    tour_system            { nil }
    association :cart
    association :tour

    after(:create) do |cart_item|
      create(:tour_locale, :pt_br, tour: cart_item.tour)
    end

    trait :true_total_price_90 do
      qtde_adulto { 1 }
      qtde_crianca { 0 }
      qtde_crianca2 { 0 }

      after(:create) do |cart_item|
        create(:tour_price, tour: cart_item.tour, preco_adulto: 90)
      end
    end

    trait :btms do
      tour_system { 'BTMS' }

      after(:create) do |cart_item|
        create(:tour_price, tour: cart_item.tour)
      end
    end

    trait :stock do
      after(:create) do |cart_item|
        tour_stock_time = create(:tour_stock_time, tour: cart_item.tour, status: 'Ativo')
        tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                                   status: 'Ativo',
                                                   subvariacao: Date.current.strftime("%d/%m/%Y"))
        cart_item.tour_system = tour_stock_date.id.to_s
        cart_item.save

        create(:tour_price, tour: cart_item.tour)
      end
    end
  end
end
