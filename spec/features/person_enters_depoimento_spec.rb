# frozen_string_literal: true

require 'rails_helper'

feature 'person enters depoimento' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'depoimentos')
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR',
                                  titulo_menu: 'Depoimentos',
                                  titulo: 'Depoimentos de clientes H2O')

    visit '/institucional/depoimentos'

    fill_in 'testimonial_nome', with: 'Will Smith'
    fill_in 'testimonial_email', with: 'smith@mib.com'
    fill_in 'testimonial_cidade', with: 'Miami'
    fill_in 'testimonial_texto', with: 'Gettin jiggy wit it'

    click_on 'Enviar'

    expect(page).not_to have_content 'Will Smith'
    expect(page).not_to have_content 'Miami'
    expect(page).not_to have_content 'Gettin jiggy wit it'
  end
end
