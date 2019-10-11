# frozen_string_literal: true

require 'rails_helper'

feature 'user enters additional information' do
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

    click_on 'Continuar'

    expect(page).to have_content 'Cliente:'
    expect(page).to have_content 'Período da Viagem:'
    expect(page).to have_content 'PASSAGEIROS'
    expect(page).to have_content 'Jake Tapper'
    expect(page).to have_content '49'
    expect(page).to have_content 'CNN'
    expect(page).to have_content 'ROTEIRO'
    expect(page).to have_content 'TOTAL'
    expect(page).to have_content 'Informações de Pagamento'
  end
end
