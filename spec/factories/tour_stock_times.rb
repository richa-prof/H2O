FactoryBot.define do
  factory :tour_stock_time do
    variacao { '23:11' }
    status   { ['Ativo','Excluido'].sample }
    association :tour
  end
end
