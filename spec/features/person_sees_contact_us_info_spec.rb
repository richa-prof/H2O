# frozen_string_literal: true

require 'rails_helper'

feature 'person sees contact us info' do
  scenario 'sucessfully' do
    institutional = create(:institutional)
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR', titulo_menu: 'Contato')

    visit root_path
    click_on 'Contato'

    expect(page).to have_css 'h1', text: 'CONTATO'

    expect(page).to have_content 'reservas@h2oecoturismo.com.br'

    expect(page).to have_css 'h2', text: 'Bonito'
    expect(page).to have_content '(Uma quadra atrás do Banco do Brasil)'

    expect(page).to have_css 'h2', text: 'Campo Grande'
    expect(page).to have_content '(Próximo ao cruzamento da Av. Mato Grosso com a R. Ceará)'

    expect(page).to have_content 'Quer fazer parte da nossa equipe?'
  end

  scenario 'sucessfully' do
    institutional = create(:institutional)
    create(:institutional_locale, institutional: institutional, locale: 'en-US', titulo_menu: 'Contact Us')

    visit '/en'
    click_on 'Contact Us'

    expect(page).to have_css 'h1', text: 'CONTACT US'

    expect(page).to have_content 'reservas@h2oecoturismo.com.br'

    expect(page).to have_css 'h2', text: 'Bonito'
    expect(page).to have_content '(Near the main square, one block from Banco do Brasil)'

    expect(page).to have_css 'h2', text: 'Campo Grande'
    expect(page).to have_content '(Near the R. Ceará and Av. Mato Grosso crossing)'

    expect(page).to have_content 'Interested in working with us?'
  end
end
