# frozen_string_literal: true

require 'rails_helper'

feature 'person clicks next from cart' do
  scenario 'successfully' do
    build_session_cart_with_tour

    visit '/carrinho/add_to_cart'

    click_on 'Continuar'

    within 'div#login_side' do
      expect(page).to have_content 'ENTRAR'
    end

    within 'div#register_side' do
      expect(page).to have_content 'CRIAR CONTA'
    end
  end
end
