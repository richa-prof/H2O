# frozen_string_literal: true

require 'rails_helper'

describe CartBuilder do
  it 'builds cart items' do
    tour = create(:tour)
    create(:tour_price, tour: tour, preco_adulto: 30)

    session_cart = {
      'tours' => {
        tour.id.to_s => {
          'tour_selected_date' => Date.current,
          'tour_selected_time' => '13:00',
          'tour_system' => 'BTMS',
          'tour_adults' => 3,
          'tour_children' => 0,
          'tour_children2' => 0,
          'tour_final_price' => 90,
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {}
    }

    object_cart = create(:cart)

    expect do
      CartBuilder.new.build_this session_cart, object_cart
    end
      .to change { CartItem.count }.from(0).to(1)

    expect( CartItem.first.produto_id ).to eq tour.id
    expect( CartItem.first.passeio_data ).to eq Date.current
    expect( CartItem.first.passeio_hora ).to eq '13:00'
    expect( CartItem.first.preco_total ).to eq 90
  end

  it 'uses items dates for cart dates' do
    first_tour = create(:tour)
    create(:tour_price, tour: first_tour)

    second_tour = create(:tour)
    create(:tour_price, tour: second_tour)

    session_cart = {
      'tours' => {
        first_tour.id.to_s => {
          'tour_selected_date' => Date.current,
          'tour_selected_time' => '13:00',
          'tour_system' => 'BTMS',
          'tour_adults' => 3,
          'tour_children' => 0,
          'tour_children2' => 0,
          'tour_final_price' => 90,
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        },
        second_tour.id.to_s => {
          'tour_selected_date' => Date.current + 3.days,
          'tour_selected_time' => '13:00',
          'tour_system' => 'BTMS',
          'tour_adults' => 3,
          'tour_children' => 0,
          'tour_children2' => 0,
          'tour_final_price' => 90,
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {}
    }

    object_cart = create(:cart)

    CartBuilder.new.build_this session_cart, object_cart

    expect( Cart.first.start_date ).to eq Date.current
    expect( Cart.first.end_date ).to eq(Date.current + 3.days)
  end

  it 'sets Cart total and subtotal' do
    tour = create(:tour)
    create(:tour_price, tour: tour, preco_adulto: 30)
    hotel = create(:hotel)

    session_cart = {
      'tours' => {
        tour.id.to_s => {
          'tour_selected_date' => Date.current,
          'tour_selected_time' => '13:00',
          'tour_system' => 'BTMS',
          'tour_adults' => 3,
          'tour_children' => 0,
          'tour_children2' => 0,
          'tour_final_price' => 90,
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {
        hotel.id.to_s => {
          'request_echo_token' => '_h2o_token_0987654321',
          'start_date' => '14/05/2050',
          'end_date' => '16/05/2050',
          'adults' => '2',
          'children_ages' => '',
          'number_of_nights' => '2',
          'room_type_name' => 'Mega Hiper Luxuoso',
          'room_selected' => '1234-5678-0',
          'sale_price' => '3.33'
        }
      }
    }

    object_cart = create(:cart, total: 0, subtotal: 0)

    expect do
      CartBuilder.new.build_this session_cart, object_cart
    end
      .to change { Cart.first.total }.from(0).to(93.33)
      .and change { Cart.first.subtotal }.from(0).to(93.33)
  end

  it 'builds cart hotels' do
    hotel = create(:hotel)

    session_cart = {
      'tours' => {},
      'hotels' => {
        hotel.id.to_s => {
          'request_echo_token' => '_h2o_token_0987654321',
          'start_date' => '14/05/2050',
          'end_date' => '16/05/2050',
          'adults' => '2',
          'children_ages' => '',
          'number_of_nights' => '2',
          'room_type_name' => 'Mega Hiper Luxuoso',
          'room_selected' => '1234-5678-0',
          'sale_price' => '9.99'
        }
      }
    }

    object_cart = create(:cart)

    expect do
      CartBuilder.new.build_this session_cart, object_cart
    end
      .to change { CartHotel.count }.from(0).to(1)

      cart_hotel = CartHotel.first

      expect( cart_hotel.hotel_id ).to eq hotel.id
      expect( cart_hotel.request_echo_token ).to eq '_h2o_token_0987654321'
      expect( cart_hotel.start_date ).to eq Date.parse('14/05/2050')
      expect( cart_hotel.end_date ).to eq Date.parse('16/05/2050')
      expect( cart_hotel.adults ).to eq 2
      expect( cart_hotel.children_ages ).to eq ''
      expect( cart_hotel.number_of_nights ).to eq 2
      expect( cart_hotel.room_type_name ).to eq 'Mega Hiper Luxuoso'
      expect( cart_hotel.room_selected ).to eq '1234-5678-0'
      expect( cart_hotel.sale_price ).to eq 9.99
  end

  it 'prefers hotel dates for cart dates' do
    tour = create(:tour)
    create(:tour_price, tour: tour)

    hotel = create(:hotel)

    session_cart = {
      'tours' => {
        tour.id.to_s => {
          'tour_selected_date' => Date.current,
          'tour_selected_time' => '13:00',
          'tour_system' => 'BTMS',
          'tour_adults' => 3,
          'tour_children' => 0,
          'tour_children2' => 0,
          'tour_final_price' => 90,
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {
        hotel.id.to_s => {
          'request_echo_token' => '_h2o_token_0987654321',
          'start_date' => '14/05/2050',
          'end_date' => '16/05/2050',
          'adults' => '2',
          'children_ages' => '',
          'number_of_nights' => '2',
          'room_type_name' => 'Mega Hiper Luxuoso',
          'room_selected' => '1234-5678-0',
          'sale_price' => '9.99'
        }
      }
    }

    object_cart = create(:cart)

    CartBuilder.new.build_this session_cart, object_cart

    expect( Cart.first.start_date ).to eq Date.parse('14/05/2050')
    expect( Cart.first.end_date ).to eq Date.parse('16/05/2050')
  end
end
