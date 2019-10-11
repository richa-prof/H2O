# frozen_string_literal: true

require 'rails_helper'

describe TourStockTime do
  it 'orders records according to time' do
    tour_stock_time_second = create(:tour_stock_time, variacao: '9:30')
    tour_stock_time_first = create(:tour_stock_time, variacao: '9:00')

    expect( TourStockTime.display_on_website.first ).to eq tour_stock_time_first
    expect( TourStockTime.display_on_website.second ).to eq tour_stock_time_second
  end

  it 'selects only active records' do
    create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_time, status: 'Excluido')

    expect( TourStockTime.count ).to eq 2
    expect( TourStockTime.active.count ).to eq 1
  end

  it 'finds options avaiable on specific date' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")
    different_date_str = (selected_date + 2.days).strftime("%d/%m/%Y")

    tour_stock_time_yes = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, status: 'Ativo', tour_stock_time: tour_stock_time_yes, subvariacao: selected_date_str)

    tour_stock_time_no = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, status: 'Ativo', tour_stock_time: tour_stock_time_no, subvariacao: different_date_str)

    expect( TourStockTime.count ).to eq 2
    expect( TourStockTime.available_on_date(selected_date).count ).to eq 1
    expect( TourStockTime.available_on_date(selected_date).first ).to eq tour_stock_time_yes
  end

  it 'considers own status in options avaiable' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour_stock_time_yes = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', tour_stock_time: tour_stock_time_yes)

    tour_stock_time_no = create(:tour_stock_time, status: 'Excluido')
    create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', tour_stock_time: tour_stock_time_no)

    expect( TourStockTime.count ).to eq 2
    expect( TourStockTime.available_on_date(selected_date).count ).to eq 1
    expect( TourStockTime.available_on_date(selected_date).first ).to eq tour_stock_time_yes
  end

  it 'considers tour_stock_date status in options avaiable' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour_stock_time_yes = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, subvariacao: selected_date_str, tour_stock_time: tour_stock_time_yes, status: 'Ativo')

    tour_stock_time_no = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, subvariacao: selected_date_str, tour_stock_time: tour_stock_time_no, status: 'Excluido')

    expect( TourStockTime.count ).to eq 2
    expect( TourStockTime.available_on_date(selected_date).count ).to eq 1
    expect( TourStockTime.available_on_date(selected_date).first ).to eq tour_stock_time_yes
  end

  it 'considers stock quantity in options avaiable' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour_stock_time_yes = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', tour_stock_time: tour_stock_time_yes,
                                                                              estoque: 1)

    tour_stock_time_no = create(:tour_stock_time, status: 'Ativo')
    create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', tour_stock_time: tour_stock_time_no,
                                                                              estoque: 0)

    expect( TourStockTime.count ).to eq 2
    expect( TourStockTime.available_on_date(selected_date).count ).to eq 1
    expect( TourStockTime.available_on_date(selected_date).first ).to eq tour_stock_time_yes
  end
end
