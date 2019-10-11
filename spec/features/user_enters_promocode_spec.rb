# frozen_string_literal: true

require 'rails_helper'

feature 'user enters promocode' do
  scenario 'for percentage discount successfully' do
    create(:cupon, chave: 'this-fun-cupon', tipo: 'Porcentagem', porcentagem: 10)

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)
    create(:cart_item, :true_total_price_90, cart: cart)

    visit '/carrinho/payment?id=' + cart.id.to_s

    fill_in 'cupom_id', with: 'this-fun-cupon'
    click_on 'Usar'

    expect(page).to have_content 'SUBTOTAL R$ 90,00'
    expect(page).to have_content 'DESCONTO R$ 9,00'
    expect(page).to have_content 'R$ 81,00'
  end

  scenario 'for BRL discount successfully' do
    create(:cupon, chave: 'this-fun-cupon', tipo: 'BRL', brl: 5.43)

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)
    create(:cart_item, :true_total_price_90, cart: cart)

    visit '/carrinho/payment?id=' + cart.id.to_s

    fill_in 'cupom_id', with: 'this-fun-cupon'
    click_on 'Usar'

    expect(page).to have_content 'SUBTOTAL R$ 90,00'
    expect(page).to have_content 'DESCONTO R$ 5,43'
    expect(page).to have_content 'R$ 84,57'
  end

  scenario 'of different kind successfully' do
    create(:cupon, chave: 'this-fun-cupon', tipo: 'Some Very Special Prize')

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)
    create(:cart_item, :true_total_price_90, cart: cart)

    visit '/carrinho/payment?id=' + cart.id.to_s

    fill_in 'cupom_id', with: 'this-fun-cupon'
    click_on 'Usar'

    expect(page).to have_content 'SUBTOTAL R$ 90,00'
    expect(page).to have_content 'TOTAL R$ 90,00'

    expect(page).not_to have_content 'DESCONTO'
  end
end
