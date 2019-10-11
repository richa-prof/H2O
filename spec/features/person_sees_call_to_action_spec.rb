# frozen_string_literal: true

require 'rails_helper'

feature 'person sees call to action' do
  scenario 'on hotel page' do
    create(:hotel_locale, :pt_br)

    visit '/hoteis'
    click_on 'Ver mais'

    expect(page).to have_content 'Achou interessante? Quer mais informações? Pronto para reservar?'
  end

  scenario 'on day by day page' do
    create(:persona, :with_locales, link: 'turista-feliz')

    visit '/perfil_de_pessoa/turista-feliz/roteiro_sugerido'

    expect(page).to have_content 'Achou interessante? Quer mais informações? Pronto para reservar?'
  end

  scenario 'on day by day English page' do
    create(:persona, :with_locales, link: 'happy')

    visit '/en/personas/happy/persona_day_by_days'

    expect(page).to have_content 'Are you interested? Would you like more information? Ready to book?'
  end

  scenario 'on special deal page' do
    create(:special_deal, :pt_br, name: 'irrelevant')

    visit '/ofertas'
    click_on 'irrelevant'

    expect(page).to have_content 'Achou interessante? Quer mais informações? Pronto para reservar?'
  end
end
