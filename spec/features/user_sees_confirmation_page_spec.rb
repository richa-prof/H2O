# frozen_string_literal: true

require 'rails_helper'

feature 'user sees confirmation page' do
  scenario 'with failed tour' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax_and_btms_item, id: 555, user: user)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    fill_in 'card_number', with: '1234567890654321'
    find('label[for=card_brand_visa]').click
    select '11', from: 'month'
    select '2038', from: 'year'
    fill_in 'cvv', with: '432'
    fill_in 'holder', with: 'Joana da Grana'
    page.execute_script("$('#terms').attr('checked', true);")

    click_on 'Continuar'

    expect(page).to have_css "img[src*='success']"
    expect(page).to have_content 'Pagamento aprovado. Suas reservas estão confirmadas!'
    expect(page).to have_content 'PD 1'
    expect(page).to have_content 'Carrinho: 555'

    expect(page).not_to have_css "img[src*='cancel']"
    expect(page).not_to have_content 'Problemas com 1 ou mais solicitações de reservas. Veja os detalhes.'
    expect(page).not_to have_content 'Problemas com o pagamento. Entre em contato com a nossa equipe!'
  end

  scenario 'for cart with stock item' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax_and_stock_item, id: 555, user: user)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    fill_in 'card_number', with: '1234567890654321'
    find('label[for=card_brand_visa]').click
    select '11', from: 'month'
    select '2038', from: 'year'
    fill_in 'cvv', with: '432'
    fill_in 'holder', with: 'Joana da Grana'
    page.execute_script("$('#terms').attr('checked', true);")

    click_on 'Continuar'

    expect(page).to have_css "img[src*='success']"
    expect(page).to have_content 'Pagamento aprovado. Suas reservas estão confirmadas!'
    expect(page).to have_content 'PD 1'
    expect(page).to have_content 'Carrinho: 555'
  end

  scenario 'with a credit card number that is not valid' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')

    user = create(:user)
    login_as user
    build_empty_session_cart

    tour_stock_time = create(:tour_stock_time, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               estoque: 9)

    cart = create(:cart, :with_pax, id: 555, user: user)
    create(:cart_item, :btms, cart: cart)
    create(:cart_item, :stock, cart: cart)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    fill_in 'card_number', with: '12345678'
    find('label[for=card_brand_visa]').click
    select '11', from: 'month'
    select '2038', from: 'year'
    fill_in 'cvv', with: '432'
    fill_in 'holder', with: 'Joana da Grana'
    page.execute_script("$('#terms').attr('checked', true);")

    click_on 'Continuar'

    expect(page).to have_css "img[src*='cancel']"
    expect(page).to have_content 'Problemas com o pagamento. Entre em contato com a nossa equipe!'
    expect(page).to have_content 'Carrinho: 555'

    expect(page).not_to have_css "img[src*='success']"
    expect(page).not_to have_content 'Pagamento aprovado. Suas reservas estão confirmadas!'
    expect(page).not_to have_content 'PD 1'
    expect(page).not_to have_content 'Problemas com 1 ou mais solicitações de reservas. Veja os detalhes.'
  end

  scenario 'and BTMS reservation fails' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')

    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, id: 555, user: user)
    tour = create(:tour, :with_price, cdgbtms_atrativo: 7_777_777_777_777_777)
    create(:cart_item, cart: cart, tour: tour, tour_system: 'BTMS')

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    fill_in 'card_number', with: '1234567890654321'
    find('label[for=card_brand_visa]').click
    select '11', from: 'month'
    select '2038', from: 'year'
    fill_in 'cvv', with: '432'
    fill_in 'holder', with: 'Joana da Grana'
    page.execute_script("$('#terms').attr('checked', true);")

    click_on 'Continuar'

    expect(page).to have_css "img[src*='cancel']"
    expect(page).to have_content 'Problemas com 1 ou mais solicitações de reservas. Veja os detalhes.'
    expect(page).to have_content 'Carrinho: 555'

    expect(page).not_to have_css "img[src*='success']"
    expect(page).not_to have_content 'Pagamento aprovado. Suas reservas estão confirmadas!'
    expect(page).not_to have_content 'PD 1'
    expect(page).not_to have_content 'Problemas com o pagamento. Entre em contato com a nossa equipe!'
  end
end
