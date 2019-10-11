# frozen_string_literal: true

require 'rails_helper'

describe HotelReservationsManager do
  describe 'availability check' do
    it 'checks if selected room is available' do
      cart = create(:cart, :with_pax, id: 555)
      hotel = create(:hotel, hotels_api_code: 5)
      cart_hotel = create(:cart_hotel, cart: cart,
                                       hotel: hotel,
                                       start_date: Date.current,
                                       end_date: (Date.current + 3.days),
                                       room_selected: '16719-23566-0')

      hotel_availability = HotelReservationsManager.new(cart).check_availability

      expect( hotel_availability[:status] ).to be true
    end

    it 'handles children ages' do
      cart = create(:cart, :with_pax, id: 555)
      hotel = create(:hotel, hotels_api_code: 5)
      cart_hotel = create(:cart_hotel, cart: cart,
                                       hotel: hotel,
                                       start_date: '2019-11-09',
                                       end_date: '2019-11-11',
                                       adults: 2,
                                       children_ages: '9',
                                       room_selected: '16719-23566-0')

      hotel_availability = HotelReservationsManager.new(cart).check_availability

      expect( hotel_availability[:status] ).to be true
    end

    it 'updates echotoken' do
      cart = create(:cart, :with_pax, id: 555)
      hotel = create(:hotel, hotels_api_code: 5)
      cart_hotel = create(:cart_hotel, cart: cart,
                                       hotel: hotel,
                                       request_echo_token: 'xyz',
                                       start_date: Date.current,
                                       end_date: (Date.current + 3.days),
                                       room_selected: '16719-23566-0')

      expect do
        HotelReservationsManager.new(cart).check_availability
      end
        .to change { CartHotel.first.request_echo_token }.from('xyz').to('api_h2o_omnibees_734bdfa2')
    end

    it 'returns id for unavailable hotel' do
      cart = create(:cart, :with_pax, id: 555)
      cart_hotel = create(:cart_hotel, cart: cart)

      hotel_availability = HotelReservationsManager.new(cart).check_availability

      expect( hotel_availability[:status] ).to be false
      expect( hotel_availability[:problem_hotel_id] ).to eq cart_hotel.hotel.id
    end
  end

  describe 'reservation creation' do
    it 'books hotel room' do
      user = create(:user, nome: 'Donna Roberta Paulsen')
      cart = create(:cart, user: user, id: 828)
      create(:cart_passenger, cart: cart, doc: 5678910)
      create(:cart_hotel, cart: cart, request_echo_token: 'api_h2o_omnibees_aa8d0e96', room_selected: '2985-3872-0')

      expect do
        HotelReservationsManager.new(cart).make_reservations
      end
        .to change { CartHotel.first.reservation_code }.from(nil).to('RES036046-1053')
        .and change { CartHotel.first.meal }.from(nil).to('Café da manhã')
    end
  end
end
