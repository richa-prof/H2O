# frozen_string_literal: true

require 'rails_helper'

describe TourAvailabilityChecker do
  it 'sets tour and date at initialize' do
    tour = create(:tour)
    selected_date = Date.current

    tour_availability_checker = TourAvailabilityChecker.new(tour,selected_date)

    expect( tour_availability_checker.instance_variable_get('@tour') ).to eq tour
    expect( tour_availability_checker.instance_variable_get('@selected_date') ).to eq selected_date
  end

  it 'checks and processes BTMS availability' do
    tour = create(:tour)
    selected_date = Date.current
    availability = [{'system' => 'BTMS', 'time' => '11:00', 'slots' => '4'}]

    expect( TourAvailabilityChecker.new(tour,selected_date).check_btms ).to eq availability
  end

  it 'logs problems with BTMS availability' do
    tour = create(:tour)
    selected_date = Date.current + 10.years
    selected_date_str = (Date.current + 10.years).strftime('%d/%m/%Y')

    TourAvailabilityChecker.new(tour,selected_date).check_btms

    expect( MyVeryOwnLog.first.authoring_class ).to eq 'TourAvailabilityChecker'
    expect( MyVeryOwnLog.first.authoring_method ).to eq 'check_btms'
    expect( MyVeryOwnLog.first.authoring_user_email ).to eq ''
    expect( MyVeryOwnLog.first.info ).to eq "Some Random Tour #{selected_date_str} [BTMS] => -1 A data pretendida está além da data limite permitida para este passeio !"
  end

  it 'makes sure tour is BTMS ready' do
    tour = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '')
    selected_date = Date.current

    expect( TourAvailabilityChecker.new(tour,selected_date).check_btms ).to eq false
  end

  it 'makes sure there is availability to return' do
    tour = create(:tour)
    selected_date = Date.current + 10.years

    expect( TourAvailabilityChecker.new(tour,selected_date).check_btms ).to eq false
  end

  it 'returns processed BTMS availability' do
    tour = create(:tour)
    selected_date = Date.current
    availability = [{'system' => 'BTMS', 'time' => '11:00', 'slots' => '4'}]

    expect( TourAvailabilityChecker.new(tour,selected_date).check_this ).to eq availability
  end

  it 'checks and processes stock availability' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour = create(:tour)
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo', variacao: '12:45')
    create(:tour_stock_date, tour_stock_time: tour_stock_time, subvariacao: selected_date_str,
                                                               id: 44,
                                                               status: 'Ativo',
                                                               estoque: 8)

    availability = [{'system' => '44', 'time' => '12:45', 'slots' => '8'}]

    expect( TourAvailabilityChecker.new(tour,selected_date).check_stock ).to eq availability
  end

  it 'makes sure tour has stock' do
    tour = create(:tour)
    selected_date = Date.current

    expect( TourAvailabilityChecker.new(tour,selected_date).check_stock ).to eq false
  end

  it 'returns processed stock availability' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '')
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo', variacao: '12:45')
    create(:tour_stock_date, tour_stock_time: tour_stock_time, subvariacao: selected_date_str,
                                                               id: 44,
                                                               status: 'Ativo',
                                                               estoque: 8)

    availability = [{'system' => '44', 'time' => '12:45', 'slots' => '8'}]

    expect( TourAvailabilityChecker.new(tour,selected_date).check_this ).to eq availability
  end

  it 'returns not available' do
    tour = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '')
    selected_date = Date.current

    expect( TourAvailabilityChecker.new(tour,selected_date).check_this ).to eq 'not available'
  end
end
