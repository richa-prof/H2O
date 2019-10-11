# frozen_string_literal: true

require 'rails_helper'

describe BTMSWrapper do
  it 'gets the authentication key at initialize' do
    btms = BTMSWrapper.new

    expect(btms.instance_variable_get('@chave')).to eq '1234abcd'
  end

  it 'gets tour availability' do
    tour = create(:tour)
    times_and_slots = { 'dados' => [[{ '07:00' => '0', '11:00' => '4' }]] }
    btms = BTMSWrapper.new

    expect(btms.check_tour_availability(tour, Date.current)).to include(times_and_slots)
  end

  it 'makes temporary reservations' do
    cart = create(:cart, :with_pax_and_btms_item, id: 555)
    reservation_info = { 'reservas' => [{
      'cdgbtms_atrativo' => '5500440033002200',
      'cdgbtms_atividade' => '9900880077006600',
      'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
      'hora' => '13:00',
      'nome' => 'Ross Geller CA 555',
      'adt' => '3',
      'chd' => '1',
      'free' => '2',
      'registros' => '1',
      'reserva_num' => 'ABCXYZ',
      'msg' => ''
    }] }
    btms = BTMSWrapper.new

    expect(btms.make_temp_reservations(cart)).to include(reservation_info)
  end

  it 'considers lunch extra when making temporary reservations' do
    cart = create(:cart, :with_pax, id: 55)
    tour = create(:tour)
    tour_extra = create(:tour_extra, tour: tour, eh_almoco: true)

    create(:cart_item, cart: cart, tour: tour, tour_system: 'BTMS')
    create(:cart_tour_extra, cart: cart, tour_extra: tour_extra, adults_qty: 5,
                             children_qty: 7,
                             children2_qty: 9,
                             unit_qty: 0)

    reservation_info = { 'reservas' => [{
      'cdgbtms_atrativo' => '5500440033002200',
      'cdgbtms_atividade' => '9900880077006600',
      'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
      'hora' => '13:00',
      'nome' => 'Ross Geller CA 55',
      'adt' => '3',
      'chd' => '1',
      'free' => '2',
      'registros' => '1',
      'reserva_num' => 'ABCXYZ',
      'msg' => ''
    }] }
    btms = BTMSWrapper.new

    expect(btms.make_temp_reservations(cart)).to include(reservation_info)
  end

  it 'makes reservations for 2 tours' do
    cart = create(:cart, :with_pax, id: 55)

    tour = create(:tour)
    tour_extra = create(:tour_extra, tour: tour, eh_almoco: true)
    create(:cart_item, cart: cart, tour: tour, tour_system: 'BTMS')
    create(:cart_tour_extra, cart: cart, tour_extra: tour_extra, adults_qty: 5,
                             children_qty: 7,
                             children2_qty: 9,
                             unit_qty: 0)

    second_tour = create(:tour, cdgbtms_atividade: 9_900_880_077_006_601)
    create(:cart_item, cart: cart, tour: second_tour, tour_system: 'BTMS')

    reservation_info = {
      'reservas' => [
        {
          'cdgbtms_atrativo' => '5500440033002200',
          'cdgbtms_atividade' => '9900880077006600',
          'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
          'hora' => '13:00',
          'nome' => 'Ross Geller CA 55',
          'adt' => '3',
          'chd' => '1',
          'free' => '2',
          'registros' => '1',
          'reserva_num' => 'ABCXYZ',
          'msg' => ''
        },
        {
          'cdgbtms_atrativo' => '5500440033002200',
          'cdgbtms_atividade' => '9900880077006601',
          'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
          'hora' => '18:00',
          'nome' => 'Ross Geller CA 55',
          'adt' => '3',
          'chd' => '1',
          'free' => '2',
          'registros' => '1',
          'reserva_num' => 'DEFXYZ',
          'msg' => ''
        }
      ]
    }
    btms = BTMSWrapper.new

    expect(btms.make_temp_reservations(cart)).to include(reservation_info)
  end

  it 'confirms temporary reservations' do
    temp_reservation = { 'reservas' => [{
      'cdgbtms_atrativo' => '5500440033002200',
      'cdgbtms_atividade' => '9900880077006600',
      'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
      'hora' => '13:00',
      'nome' => 'Ross Geller CA 555',
      'adt' => '3',
      'chd' => '1',
      'free' => '2',
      'registros' => '1',
      'reserva_num' => 'ABCXYZ',
      'msg' => ''
    }] }
    confirmation_return = { '0' => [[{
      'reserva_num' => '296553',
      'registros' => '1',
      'cdg_erro' => '0',
      'msg' => ''
    }]] }
    btms = BTMSWrapper.new

    expect(btms.confirm_reservations(temp_reservation)).to include(confirmation_return)
  end

  it 'renames reservations' do
    itinerary_tour = create(:itinerary_tour)
    renamed_return = { 'reservas' => [{
      'cdgbtms_atrativo' => '5500440033002200',
      'cdgbtms_atividade' => '9900880077006600',
      'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
      'hora' => '13:00',
      'nome' => 'Ross Geller PD 1',
      'adt' => '3',
      'chd' => '1',
      'free' => '2',
      'registros' => '1',
      'reserva_num' => 'ABCXYZ',
      'msg' => ''
    }] }
    btms = BTMSWrapper.new

    expect(btms.rename_reservation(itinerary_tour)).to include(renamed_return)
  end

  it 'renames reservations that include lunch' do
    itinerary = create(:itinerary, id: 5)
    itinerary_tour = create(:itinerary_tour, itinerary: itinerary, qtde_adt_almoco: 77,
                                             qtde_chd_almoco: 33,
                                             qtde_free_almoco: 55)

    renamed_return = { 'reservas' => [{
      'cdgbtms_atrativo' => '5500440033002200',
      'cdgbtms_atividade' => '9900880077006600',
      'data' => (Date.current + 3.days).strftime('%d/%m/%Y'),
      'hora' => '13:00',
      'nome' => 'Ross Geller PD 5',
      'adt' => '3',
      'chd' => '1',
      'free' => '2',
      'registros' => '1',
      'reserva_num' => 'ABCXYZ',
      'msg' => ''
    }] }
    btms = BTMSWrapper.new

    expect(btms.rename_reservation(itinerary_tour)).to include(renamed_return)
  end
end
