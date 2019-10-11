# frozen_string_literal: true

require 'rails_helper'

feature 'person sees depoimentos page' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'depoimentos')
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR',
                                  titulo_menu: 'Depoimentos',
                                  titulo: 'Depoimentos de clientes H2O')
    create(:testimonial, institutional: institutional, nome: 'Lewis Litt',
                         email: 'meu-email@dominio.com',
                         texto: 'Tudo foi muito bom!',
                         cidade: 'Stars Hollow')

    visit '/institucional/depoimentos'

    expect(page).to have_content 'Depoimentos de clientes H2O'
    expect(page).to have_content 'Tudo foi muito bom!'
    expect(page).to have_content 'Stars Hollow'
    expect(page).not_to have_content 'meu-email@dominio.com'
  end
end
