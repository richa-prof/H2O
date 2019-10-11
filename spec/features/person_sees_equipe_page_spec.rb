# frozen_string_literal: true

require 'rails_helper'

feature 'person sees equipe page' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'equipe')
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR', titulo_menu: 'Equipe H2O', titulo: 'Conheça a equipe!')
    staff = create(:staff, institutional: institutional, nome: 'Lewis Litt')
    create(:staff_locale, staff: staff, cargo: 'Assistente de Carimbador II', locale: 'pt-BR')

    visit '/institucional/equipe'

    expect(page).to have_content 'Conheça a equipe!'
    expect(page).to have_content 'Lewis Litt'
    expect(page).to have_content 'Assistente de Carimbador II'
    expect( find('div.images')['innerHTML'] ).to include 'test_imagem_1'
  end
end
