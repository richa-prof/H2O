# frozen_string_literal: true

require 'rails_helper'

describe Cart do
  it 'scopes out records with associated itinerary' do
    create_list(:cart, 3, :converted)
    create_list(:cart, 2)

    expect( Cart.count ).to eq 5
    expect( Cart.in_process.count ).to eq 2
    expect( Cart.converted.count ).to eq 3
  end

  it 'checks for BTMS items' do
    cart_yes = create(:cart)
    create(:cart_item, :btms, cart: cart_yes)

    cart_no = create(:cart)
    create(:cart_item, :stock, cart: cart_no)

    expect( cart_yes.has_btms_items? ).to eq true
    expect( cart_no.has_btms_items? ).to eq false
  end

  it 'checks for stock items' do
    cart_yes = create(:cart)
    create(:cart_item, :stock, cart: cart_yes)

      cart_no = create(:cart)
      create(:cart_item, :btms, cart: cart_no)

    expect( cart_yes.has_stock_items? ).to eq true
    expect( cart_no.has_stock_items? ).to eq false
  end

  it 'refreshes tour prices' do
    tour = create(:tour)
    cart = create(:cart)
    create(:cart_item, cart: cart, tour: tour, qtde_adulto: 5,
                                               qtde_crianca: 3,
                                               qtde_crianca2: 1,
                                               preco_adulto: 50,
                                               preco_crianca: 30,
                                               preco_crianca2: 10,
                                               preco_total: 350,
                                               passeio_data: '14/05/2050')

     create(:cart_item, cart: cart, passeio_data: '01/01/2001')

     create(:tour_price, tour: tour, inicio: '10/05/2050', fim: '20/05/2050',
                                     preco_adulto: 600, preco_crianca: 400, preco_crianca2: 200)

     expect do
       cart.refresh_tour_prices
     end
      .to change{ CartItem.count }.from(2).to(1)
      .and change{ CartItem.first.preco_adulto }.from(50).to(600)
      .and change{ CartItem.first.preco_crianca }.from(30).to(400)
      .and change{ CartItem.first.preco_crianca2 }.from(10).to(200)
      .and change{ CartItem.first.preco_total }.from(350).to(4400)
  end

  it 'considers extras in tour prices refresh' do
    tour = create(:tour)
    tour_extra = create(:tour_extra, tour: tour)

    cart = create(:cart)
    create(:cart_item, cart: cart, tour: tour, qtde_adulto: 5,
                                               qtde_crianca: 3,
                                               qtde_crianca2: 1,
                                               preco_adulto: 50,
                                               preco_crianca: 30,
                                               preco_crianca2: 10,
                                               preco_total: 350,
                                               passeio_data: '14/05/2050')

    create(:cart_tour_extra, cart: cart, tour_extra: tour_extra, adults_qty: 5, children_qty: 3, children2_qty: 1, unit_qty: 0)

    create(:tour_price, tour: tour, inicio: '10/05/2050', fim: '20/05/2050',
                                    preco_adulto: 0, preco_crianca: 0, preco_crianca2: 0)

    create(:tour_extra_price, tour_extra: tour_extra, inicio: '10/05/2050', fim: '20/05/2050',
                                                      preco_adulto: 6, preco_crianca: 4, preco_crianca2: 2)

    expect do
       cart.refresh_tour_prices
    end
      .to change{ CartItem.first.preco_total }.from(350).to(44)
  end

  it 'destroys cart items for tours with no price' do
    cart_item = create(:cart_item)

     expect do
       cart_item.cart.refresh_tour_prices
     end
      .to change{ CartItem.count }.by(-1)
  end

  it 'considers extras when destroying cart items' do
    cart_item = create(:cart_item)

    tour_extra = create(:tour_extra, tour: cart_item.tour)
    create(:cart_tour_extra, cart: cart_item.cart, tour_extra: tour_extra)

     expect do
       cart_item.cart.refresh_tour_prices
     end
      .to change{ CartItem.count }.by(-1)
      .and change{ CartTourExtra.count }.by(-1)
  end

  it 'destroys tours extras with no price' do
    cart_item = create(:cart_item)

    tour_extra = create(:tour_extra, tour: cart_item.tour)
    create(:cart_tour_extra, cart: cart_item.cart, tour_extra: tour_extra)

    create(:tour_price, tour: cart_item.tour)

     expect do
       cart_item.cart.refresh_tour_prices
     end
      .to change{ CartItem.count }.by(0)
      .and change{ CartTourExtra.count }.by(-1)
  end

  it 'adds all prices in items and hotels' do
    cart = create(:cart, subtotal: 0, desconto: 0, total: 0)
    cart_item = create(:cart_item, cart: cart, preco_total: 2.22)
    create(:cart_hotel, cart: cart, sale_price: 3.33)

    expect( cart.add_all_prices ).to eq 5.55
  end

  it 'self refreshes subtotal and total' do
    cart = create(:cart, subtotal: 0, desconto: 1.05, total: 0)
    cart_item = create(:cart_item, cart: cart, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
    create(:tour_price, tour: cart_item.tour, preco_adulto: 2.22)
    create(:cart_hotel, cart: cart, sale_price: 3.33)

    expect do
      cart.refresh_totals
    end
     .to change{ cart.subtotal }.to(5.55)
     .and change{ cart.total }.to(4.5)
  end
end
