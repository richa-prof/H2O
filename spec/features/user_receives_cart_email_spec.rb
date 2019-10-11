# frozen_string_literal: true

require 'rails_helper'

feature 'user receives cart e-mail' do
  scenario 'successfully' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, id: 5, subtotal: 0, desconto: 0, total: 0)
    cart_item = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, preco_adulto: 2.22)
    cart_hotel = create(:cart_hotel, :pt_br, cart: cart, room_type_name: 'Standard', sale_price: 3.33)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    subject = ActionMailer::Base.deliveries.last.subject
    body = ActionMailer::Base.deliveries.last.body.raw_source.squish

    expect(subject).to have_content 'CA 5 - Reservas Solicitadas'

    expect(body).to have_content 'EU VOU PARA BONITO CA 5'

    expect(body).to have_content cart_item.tour.tour_locales.where(locale: 'pt-BR').first.nome
    expect(body).to have_content 'R$ 2,22'

    expect(body).to have_content cart_hotel.hotel.hotel_locales.where(locale: 'pt-BR').first.nome
    expect(body).to have_content 'Standard'
    expect(body).to have_content 'R$ 3,33'

    expect(body).to have_content 'TOTAL R$ 5,55'

    expect(body).to have_content 'Reservas ainda não efetuadas.'
    expect(body).to have_content 'Preços e disponibilidades sujeitos a alteração.'
  end

  scenario 'with discount' do
    user = create(:user)
    login_as user
    build_empty_session_cart

    cart = create(:cart, :with_pax, user: user, subtotal: 0, desconto: 1.05, total: 0)
    cart_item = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, preco_adulto: 2.22)
    create(:cart_hotel, :pt_br, cart: cart, sale_price: 3.33)

    visit "/carrinho/payment?id=#{cart.id.to_s}"

    body = ActionMailer::Base.deliveries.last.body.raw_source.squish

    expect(body).to have_content 'TOTAL R$ 5,55 - R$ 1,05 = R$ 4,50'
  end
end
