# frozen_string_literal: true

require 'rails_helper'

feature 'user enters two pax' do
  scenario 'successfully' do
    log_user_in
    build_session_cart_with_tour
    create(:location, nome: 'Pousadinha')

    visit '/carrinho/additional_information'

    select 'Pousadinha', from: 'cart_localizacao'
    fill_in 'telefone', with: '+55 (12) 1234-1234'

    fill_in 'cart_cart_passengers_attributes_0_nome', with: 'Jake Tapper'
    fill_in 'cart_cart_passengers_attributes_0_idade', with: '49'
    fill_in 'cart_cart_passengers_attributes_0_doc', with: 'CNN'

    click_on 'Acrescentar'

    all('input[placeholder="Nome"]')[1].set 'Sean Hannity'
    all('input[placeholder="Idade"]')[1].set '56'
    all('input[placeholder="Documento"]')[1].set 'Fox News'

    click_on 'Continuar'

    expect(page).to have_content 'Jake Tapper'
    expect(page).to have_content '49'
    expect(page).to have_content 'CNN'

    expect(page).to have_content 'Sean Hannity'
    expect(page).to have_content '56'
    expect(page).to have_content 'Fox News'
  end
end
