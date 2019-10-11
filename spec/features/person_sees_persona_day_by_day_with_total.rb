# frozen_string_literal: true

require 'rails_helper'

feature 'person sees persona day by day with total' do
  scenario 'sucessfully' do
    persona = create(:persona, :with_locales, link: 'turista-feliz')

    tour_price_type = create(:tour_price_type)

    tour_1 = create(:tour, :with_locales)
    create(:tour_price, tour_price_type: tour_price_type, tour: tour_1, preco_adulto: 100)

    tour_2 = create(:tour, :with_locales)
    create(:tour_price, tour_price_type: tour_price_type, tour: tour_2, preco_adulto: 25)

    create(:persona_day_by_day, persona: persona, tour: tour_1)
    create(:persona_day_by_day, persona: persona, tour: tour_2)

    visit '/perfil_de_pessoa/turista-feliz/roteiro_sugerido'

    within('#day_by_day_prices_sum') do
      expect(page).to have_content 'R$ 125,00 por adulto'
    end
  end
end
