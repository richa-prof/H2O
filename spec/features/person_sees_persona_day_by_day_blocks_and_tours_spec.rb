# frozen_string_literal: true

require 'rails_helper'

feature 'person sees persona day by day blocks and tours' do
  scenario 'sucessfully' do
    persona = create(:persona, :with_locales, link: 'turista-feliz')

    block_am = create(:block)
    create(:block_locale, block: block_am, locale: 'pt-BR', nome: 'Manhã')

    block_pm = create(:block)
    create(:block_locale, block: block_pm, locale: 'pt-BR', nome: 'Tarde')

    tour_am = create(:tour)
    create(:tour_locale, tour: tour_am, locale: 'pt-BR', nome: 'Passeio Legal')

    tour_pm = create(:tour)
    create(:tour_locale, tour: tour_pm, locale: 'pt-BR', nome: 'Algo divertido')

    create(:persona_day_by_day, persona: persona, day_order: 1, block: block_am, tour: tour_am)
    create(:persona_day_by_day, persona: persona, day_order: 2, block: block_pm, tour: tour_pm)

    visit '/perfil_de_pessoa/turista-feliz/roteiro_sugerido'

    within('#day_1') do
      expect(page).to have_content 'Manhã: Passeio Legal'
    end

    within('#day_2') do
      expect(page).to have_content 'Tarde: Algo divertido'
    end
  end
end
