FactoryBot.define do
  factory :search_history do
    searched_term     { 'Find me something cool.' }
    number_of_results { 1 }
    locale            { 'pt-BR' }
  end
end
