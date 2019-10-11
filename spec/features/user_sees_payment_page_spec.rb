# frozen_string_literal: true

require 'rails_helper'

feature 'user sees payment page' do
  scenario 'successfully' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0,
                                                desconto: 0,
                                                total: 0,
                                                start_date: '13/05/2050',
                                                end_date: '15/05/2050')

    cart_item = create(:cart_item, cart: cart, passeio_data: '14/05/2050',
                                               passeio_hora: '13:00',
                                               qtde_adulto: 1,
                                               qtde_crianca: 0,
                                               qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, inicio: '01/01/2000', fim: '31/12/2500', preco_adulto: 90)

    cart_hotel = create(:cart_hotel, :pt_br, cart: cart, start_date: '13/05/2050',
                                                         end_date: '15/05/2050',
                                                         number_of_nights: 2,
                                                         room_type_name: 'Mega Luxo',
                                                         sale_price: 300)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_content 'Período da Viagem: 13/05/2050 a 15/05/2050'

    expect(page).to have_css 'h3', text: 'ROTEIRO'
    expect(page).to have_css 'h3', text: 'HOSPEDAGEM'

    within 'table#cart_items' do
      expect(page).to have_content 'Data Hora Passeio Preço'
      expect(page).to have_content '14/05/2050'
      expect(page).to have_content '13:00'
      expect(page).to have_content cart_item.tour.tour_locales.where(locale: 'pt-BR').first.nome
      expect(page).to have_content 'R$ 90,00'
    end

    within 'table#cart_hotels' do
      expect(page).to have_content 'Entrada Saída Tipo de Apartamento Valor'
      expect(page).to have_content '13/05/2050 15/05/2050'
      expect(page).to have_content "#{cart_hotel.hotel.hotel_locales.where(locale: 'pt-BR').first.nome} - Mega Luxo"
      expect(page).to have_content '2 diária(s) por R$ 300,00'
    end

    expect(page).to have_content 'SUBTOTAL R$ 390,00'
    expect(page).to have_content 'TOTAL R$ 390,00'

    expect(page).not_to have_content 'DESCONTO'
  end

  scenario 'for a cart with only tours' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user)
    cart_item = create(:cart_item, cart: cart)
    create(:tour_price, tour: cart_item.tour)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_css 'h3', text: 'ROTEIRO'
    expect(page).not_to have_content 'HOSPEDAGEM'
  end

  scenario 'for a cart with only hotels' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user)
    cart_hotel = create(:cart_hotel, :pt_br, cart: cart)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_css 'h3', text: 'HOSPEDAGEM'
    expect(page).not_to have_content 'ROTEIRO'
  end

  scenario 'for a two item cart' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)

    cart_item_30 = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item_30.tour, preco_adulto: 30.30)

    cart_item_15 = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item_15.tour, preco_adulto: 15.15)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_content 'R$ 30,30'
    expect(page).to have_content 'R$ 15,15'
    expect(page).to have_content 'TOTAL R$ 45,45'
  end

  scenario 'for a cart with tour and hotel' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)
    cart_item = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, preco_adulto: 2.22)
    create(:cart_hotel, :pt_br, cart: cart, sale_price: 3.33)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_content 'SUBTOTAL R$ 5,55'
    expect(page).to have_content 'TOTAL R$ 5,55'
  end

  scenario 'for a cart with high priced tour and hotel' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 0, total: 0)
    cart_item = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, preco_adulto: 20000000)
    create(:cart_hotel, :pt_br, cart: cart, sale_price: 30000)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    expect(page).to have_content 'SUBTOTAL R$ 20.030.000,00'
    expect(page).to have_content 'TOTAL R$ 20.030.000,00'
  end
end
