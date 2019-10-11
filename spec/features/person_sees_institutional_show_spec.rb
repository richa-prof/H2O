# frozen_string_literal: true

require 'rails_helper'

feature 'person sees institutional show' do
  scenario 'sucessfully' do
    create(:institutional_locale, titulo: 'Algo Bem Importante',
                                  titulo_menu: 'Informações',
                                  texto: 'Esta informação fará toda a diferença na sua viagem!',
                                  metatag_titulo: 'Veja que máximo estas informações:',
                                  locale: 'pt-BR')

    visit root_path
    click_on 'Informações'

    expect(page).to have_title 'Veja que máximo estas informações:'
    expect(page).to have_css 'h1', text: 'INFORMAÇÕES'
    expect(page).to have_css 'h2', text: 'Algo Bem Importante'
    expect(page).to have_content 'Esta informação fará toda a diferença na sua viagem!'
  end
end
