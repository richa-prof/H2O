# frozen_string_literal: true

require 'rails_helper'

feature 'user clicks next from cart' do
  scenario 'successfully' do
    log_user_in
    build_session_cart_with_tour

    visit '/carrinho/add_to_cart'

    click_on 'Continuar'

    expect(page).to have_content 'Localização'
    expect(page).to have_content 'Telefone'
    expect(page).to have_content 'Informações dos Passageiros'
  end
end
