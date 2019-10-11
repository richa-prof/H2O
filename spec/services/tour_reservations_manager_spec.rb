# frozen_string_literal: true

require 'rails_helper'

describe TourReservationsManager do
  it 'sets up BTMS and cart at initialize' do
    cart = create(:cart)
    tour_reservations_manager = TourReservationsManager.new(cart)

    expect( tour_reservations_manager.instance_variable_get('@cart') ).to eq cart
    expect( tour_reservations_manager.instance_variable_get('@btms') ).to be_a BTMSWrapper
  end

  it 'makes temporary reservations in BTMS' do
    cart = create(:cart, :with_pax_and_btms_item, id: 555)
    tour_reservations_manager = TourReservationsManager.new(cart)

    expect( tour_reservations_manager.make_temp_reservations[:status] ).to eq true
  end

  it 'returns id for tour with BTMS problem' do
    tour = create(:tour, id: 5,
                         cdgbtms_atrativo: '7777777777777777',
                         cdgbtms_atividade: '9900880077006600')
    cart = create(:cart, :with_pax, id: 555)
    create(:cart_item, tour: tour, cart: cart, tour_system: 'BTMS')
    tour_reservations_manager = TourReservationsManager.new(cart)

    temp_reservations = tour_reservations_manager.make_temp_reservations

    expect( temp_reservations[:status] ).to eq false
    expect( temp_reservations[:problem_tour_id] ).to eq 5
  end

  it 'logs BTMS problem' do
    tour = create(:tour, id: 5,
                         cdgbtms_atrativo: '7777777777777777',
                         cdgbtms_atividade: '9900880077006600')
    cart = create(:cart, :with_pax, id: 555)
    create(:cart_item, tour: tour, cart: cart, tour_system: 'BTMS')

    TourReservationsManager.new(cart).make_temp_reservations

    expect( MyVeryOwnLog.first.authoring_class ).to eq 'TourReservationsManager'
    expect( MyVeryOwnLog.first.authoring_method ).to eq 'handle_btms_temp_reservations'
    expect( MyVeryOwnLog.first.authoring_user_email ).to eq cart.user.email
    expect( MyVeryOwnLog.first.info ).to eq 'CA 555 Some Random Tour => (102) Não há vagas suficientes a partir deste horário ! 14'
  end

  it 'hadles stock items' do
    tour_stock_time = create(:tour_stock_time, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               numero_de_reserva: 'BISC8',
                                               estoque: 9)
    cart = create(:cart)
    create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                   qtde_adulto: 3,
                                   qtde_crianca: 3,
                                   qtde_crianca2: 3)

    tour_reservations_manager = TourReservationsManager.new(cart)

    expect do
      @temp_reservations = tour_reservations_manager.make_temp_reservations
    end
      .to change{ TourStockDate.first.estoque }.from(9).to(0)
      .and change{ CartItem.first.reserva }.from(nil).to('BISC8')

    expect( @temp_reservations[:status] ).to eq true
  end

  it 'hadles nil and zero quantities in stock items' do
    tour_stock_time = create(:tour_stock_time, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               numero_de_reserva: 'BISC8',
                                               estoque: 9)
    cart = create(:cart)
    create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                   qtde_adulto: 3,
                                   qtde_crianca: 0,
                                   qtde_crianca2: nil)

    tour_reservations_manager = TourReservationsManager.new(cart)

    expect do
      @temp_reservations = tour_reservations_manager.make_temp_reservations
    end
      .to change{ TourStockDate.first.estoque }.from(9).to(6)
      .and change{ CartItem.first.reserva }.from(nil).to('BISC8')

    expect( @temp_reservations[:status] ).to eq true
  end

  it 'returns id for tour with stock problem' do
    tour = create(:tour, id: 505)
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               estoque: 9)
    cart = create(:cart)
    cart_item = create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                               tour: tour,
                                               qtde_adulto: 3,
                                               qtde_crianca: 3,
                                               qtde_crianca2: 4)

    tour_reservations_manager = TourReservationsManager.new(cart)

    temp_reservations = tour_reservations_manager.make_temp_reservations

    expect( temp_reservations[:status] ).to eq false
    expect( temp_reservations[:problem_tour_id] ).to eq 505
  end

  it 'returns false for problem in BTMS only' do
    tour = create(:tour, cdgbtms_atrativo: '7777777777777777',
                         cdgbtms_atividade: '9900880077006600')

    tour_stock_time = create(:tour_stock_time, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               estoque: 9)

    cart = create(:cart, :with_pax, id: 555)

    create(:cart_item, tour: tour, cart: cart, tour_system: 'BTMS')
    create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                   qtde_adulto: 3,
                                   qtde_crianca: 3,
                                   qtde_crianca2: 3)

    tour_reservations_manager = TourReservationsManager.new(cart)
    temp_reservations = tour_reservations_manager.make_temp_reservations

    expect( temp_reservations[:status_btms] ).to eq false
    expect( temp_reservations[:status_stock] ).to eq true
    expect( temp_reservations[:status] ).to eq false
  end

  it 'returns false for problem in stock only' do
    cart = create(:cart, :with_pax_and_btms_item, id: 555)

    tour = create(:tour, id: 505)
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               estoque: 9)

    cart_item = create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                               tour: tour,
                                               qtde_adulto: 3,
                                               qtde_crianca: 3,
                                               qtde_crianca2: 4)

    tour_reservations_manager = TourReservationsManager.new(cart)

    temp_reservations = tour_reservations_manager.make_temp_reservations

    expect( temp_reservations[:status_btms] ).to eq true
    expect( temp_reservations[:status_stock] ).to eq false
    expect( temp_reservations[:status] ).to eq false
  end

  it 'confirms BTMS temporary reservations' do
    cart = create(:cart, :with_pax_and_btms_item, id: 555)
    tour_reservations_manager = TourReservationsManager.new(cart)
    tour_reservations_manager.make_temp_reservations

    expect( tour_reservations_manager.confirm_reservations ).to eq true
  end

  it 'returns stock slots' do
    tour_stock_time = create(:tour_stock_time, status: 'Ativo')
    tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time,
                                               status: 'Ativo',
                                               id: 708,
                                               numero_de_reserva: 'BISC8',
                                               estoque: 9)
    cart = create(:cart)
    create(:cart_item, cart: cart, tour_system: tour_stock_date.id.to_s,
                                   reserva: 'BISC8',
                                   qtde_adulto: 3,
                                   qtde_crianca: 3,
                                   qtde_crianca2: 3)

    tour_reservations_manager = TourReservationsManager.new(cart)

    expect do
      tour_reservations_manager.cancel_reservations
    end
      .to change{ TourStockDate.first.estoque }.from(9).to(18)
      .and change{ CartItem.first.reserva }.from('BISC8').to('(estoque devolvido)')
  end
end
