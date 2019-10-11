# frozen_string_literal: true

require 'rails_helper'

feature 'person sees hotel availability' do
  scenario 'in Portuguese' do
    create(:hotel, :pt_br, hotels_api_code: 5, link: 'this-hotel')

    visit '/hoteis/this-hotel'

    expect(page).to have_content 'Luxo Quarto espaçoso, com vista mar. 3 diária(s) por R$ 219,44'
    expect(page).to have_content 'Taxa(s) incluída(s): R$ 23,88'
    expect(page).to have_content 'Feriado Independencia Horário de check-in a partir das 14:00 horas'
    expect(page).to have_content 'Non-refundable Rate This rate is a non-refundable rate'

    expect(page).to have_content 'Suíte Executiva Espaçosas e confortáveis suítes 3 diária(s) por R$ 555,33'
    expect(page).not_to have_content 'Taxa(s) incluída(s): R$ 0,00'
    expect(page).to have_content 'Regime Café da manhã'
    expect(page).to have_content 'Condições Gerais Horário de Check-in: 14:00 horas'
    expect(page).to have_content 'cancelamento 24 Cancelamento permitido ate 24 horas antes da data de chegada.'
  end

  scenario 'in English' do
    create(:hotel, :with_locale, hotels_api_code: 5, link: 'this-hotel')

    visit '/en/hotels/this-hotel'

    expect(page).to have_content 'Deluxe ocean view 3 night(s) for 219.44 BRL'
    expect(page).to have_content 'Independence Day check in at 2 pm'
    expect(page).to have_content 'Included tax(es): 23.88 BRL'
  end
end
