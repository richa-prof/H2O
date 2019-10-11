# frozen_string_literal: true

require 'rails_helper'

describe CartCharger do
  it 'returns successful confirmation information' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    cart = create(:cart, :with_pax_and_btms_item, id: 555)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 1
    }

    confirmation_params = CartCharger.new.charge cart, params

    expect( confirmation_params[:id] ).to eq 555
    expect( confirmation_params[:img] ).to eq 'success.png'
    expect( confirmation_params[:itinerary_id] ).to eq 1
    expect( confirmation_params[:sale_status] ).to eq '2'
    expect( confirmation_params[:sale_return_code] ).to eq '6'
  end

  it 'makes tour and hotel reservations' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    user = create(:user, nome: 'Donna Roberta Paulsen')
    cart = create(:cart, user: user, id: 828)
    create(:cart_item, :btms, cart: cart)
    create(:cart_passenger, cart: cart, doc: 5678910)
    hotel = create(:hotel, :pt_br, hotels_api_code: 5)
    create(:cart_hotel, cart: cart, hotel: hotel, request_echo_token: 'api_h2o_omnibees_aa8d0e96',
                                                  start_date: '2019-11-09',
                                                  end_date: '2019-11-11',
                                                  adults: 2,
                                                  children_ages: '9',
                                                  room_selected: '2985-3872-0')

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 1
    }

    expect do
      CartCharger.new.charge cart, params
    end
      .to change { CartItem.first.reserva }.from(nil).to('654321')
      .and change { CartHotel.first.reservation_code }.from(nil).to('RES036046-1053')
  end

  it 'returns failed temp tour confirmation information' do
    cart = create(:cart, :with_pax, id: 555)
    tour = create(:tour, :with_price, cdgbtms_atrativo: 7_777_777_777_777_777)
    create(:cart_item, cart: cart, tour: tour, tour_system: 'BTMS')

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 1
    }

    confirmation_params = CartCharger.new.charge cart, params

    expect( confirmation_params[:id] ).to eq 555
    expect( confirmation_params[:img] ).to eq 'cancel.png'
    expect( confirmation_params[:temp_reservations_status] ).to eq 'false'
    expect( confirmation_params[:problem_item_class] ).to eq 'Tour'
    expect( confirmation_params[:problem_item_id] ).to eq tour.id
  end

  it 'returns failed hotel confirmation information' do
    cart = create(:cart, :with_pax, id: 555)
    cart_hotel = create(:cart_hotel, cart: cart)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 1
    }

    confirmation_params = CartCharger.new.charge cart, params

    expect( confirmation_params[:id] ).to eq 555
    expect( confirmation_params[:img] ).to eq 'cancel.png'
    expect( confirmation_params[:problem_item_class] ).to eq 'Hotel'
    expect( confirmation_params[:problem_item_id] ).to eq cart_hotel.hotel.id
  end
end
