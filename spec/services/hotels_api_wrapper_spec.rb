# frozen_string_literal: true

require 'rails_helper'

describe HotelsAPIWrapper do
  it 'gets current token at initialize' do
    hotel_api = HotelsAPIWrapper.new

    expect( hotel_api.instance_variable_get('@token') ).to eq '1234abcd'
    expect( hotel_api.instance_variable_get('@expires_at') ).to eq 'Wed, 14 May 2025 05:04:00.018000000 +0000'
  end

  it 'gets list of hotels with ids' do
    hotel_list = HotelsAPIWrapper.new.list_hotels

    first_option = {
      'id' => 2,
      'name' => 'São Paulo 1054'
    }

    second_option = {
      'id' => 5,
      'name' => 'Omnibees Test 1053'
    }

    expect( hotel_list ).to include first_option
    expect( hotel_list ).to include second_option
  end

  it 'requests availability information' do
    guest_count = [{
      total: 3,
      adults: 2,
      children: 1,
      children_ages: [9]
    }]

    availability_request_info = {
      guest_count: guest_count,
      hotel_id: 5,
      start_date: '2019-11-09',
      end_date: '2019-11-11'
    }

    first_option = {
      '16719-23566-0' => {
        'rate' => 226,
        'is_marked_up' => false,
        'taxes' => 0
      }
    }

    second_option = {
      '2985-3872-0' => {
        'rate' => 409.5,
        'is_marked_up' => true,
        'taxes' => 0
      }
    }

    availability = HotelsAPIWrapper.new.availability availability_request_info
    room_rates = availability['room_rates']

    expect( room_rates ).to include first_option
    expect( room_rates ).to include second_option
  end

  it 'requests availability information in English' do
    guest_count = [{
      total: 2,
      adults: 2,
      children: 0,
      children_ages: []
    }]

    availability_request_info = {
      guest_count: guest_count,
      hotel_id: 5,
      start_date: Date.current.strftime('%Y-%m-%d'),
      end_date: (Date.current + 3.days).strftime('%Y-%m-%d')
    }

    rate_plan = {
      '3872' => {
        "name" => "Night",
        "first_info" => "Breakfast at restaurant.",
        "additional_info_name" => "General Conditions",
        "additional_info_description" => "Check-in at 2 pm",
        "guarantee_name" => "Guaranteed",
        "guarantee_description" => "Reservations only if guaranteed",
        "cancelation_name" => "24-hour cancelation",
        "cancelation_description" => "24 hours prior is ok",
        "meal" => "Breakfast",
        "offers" => {},
        "included_extras" => [],
        "comission" => 0
      }
    }

    availability = HotelsAPIWrapper.new.availability availability_request_info, 'en-US'
    rate_plans = availability['rate_plans']

    expect( rate_plans ).to include rate_plan
  end

  it 'informs when there is no availability' do
    guest_count = [{
      total: 2,
      adults: 2,
      children: 0,
      children_ages: []
    }]

    availability_request_info = {
      guest_count: guest_count,
      hotel_id: 5,
      start_date: '2019-11-01',
      end_date: '2019-11-01'
    }

    availability = HotelsAPIWrapper.new.availability availability_request_info

    expect( availability ).to eq 'no availability'
  end

  it 'makes reservations' do
    echo_token = 'api_h2o_omnibees_aa8d0e96'

    room_distribution = [{
      client_name: 'Donna Roberta Paulsen',
      client_doc: '5678910',
      foreign_info: 'CA 828',
      guest_names: [],
      selected_room: '2985-3872-0',
      optional_extras: []
    }]

    reservation_info = {
      'reservation_code' => 'RES036046-1053',
      'grand_total' => 409.5,
      'room_breakdown' => [{
        'total_price' => 409.5,
        'room_info' => 'Suíte Executiva (Ocupação máxima: 3)',
        'terms_info' => 'Horário de Check-in: 14:00 horas',
        'cancellation_name' => 'cancelamento 24',
        'cancellation_description' => 'Cancelamento permitido ate 24 horas antes da data de chegada.',
        'meal' => 'Café da manhã',
        'optional_extras' => [],
        'included_extras' => []
      }]
    }

    reservation_info_returned = HotelsAPIWrapper.new.reservation echo_token, room_distribution

    expect( reservation_info_returned ).to eq reservation_info
  end

  it 'makes reservations in English' do
    echo_token = 'api_h2o_omnibees_aa8d0e96'

    room_distribution = [{
      client_name: 'Donna Roberta Paulsen',
      client_doc: '5678910',
      foreign_info: 'CA 828',
      guest_names: [],
      selected_room: '2985-3872-0',
      optional_extras: []
    }]

    reservation_info = {
      'reservation_code' => 'RES036046-1053',
      'grand_total' => 409.5,
      'room_breakdown' => [{
        'total_price' => 409.5,
        'room_info' => 'Executive Suite (Max Occupants: 3)',
        'terms_info' => 'check in at 2 pm',
        'cancellation_name' => '24 hours',
        'cancellation_description' => '24 hours prior to check in',
        'meal' => 'breakfast',
        'optional_extras' => [],
        'included_extras' => []
      }]
    }

    reservation_info_returned = HotelsAPIWrapper.new.reservation echo_token, room_distribution, 'en-US'

    expect( reservation_info_returned ).to eq reservation_info
  end
end
