# frozen_string_literal: true

require 'rails_helper'

feature 'person sees persona day by day with prices' do
  scenario 'sucessfully' do
    persona = create(:persona, :with_locales, link: 'turista-feliz')
    tour = create(:tour, :with_locales)
    create(:tour_price, tour: tour, preco_adulto: 100)

    create(:persona_day_by_day, persona: persona, tour: tour)

    visit '/perfil_de_pessoa/turista-feliz/roteiro_sugerido'

    expect(page).to have_content 'R$ 100,00 por adulto'
  end
end
