# frozen_string_literal: true

require 'rails_helper'

describe TourStockDate do
  it 'orders records according to date' do
    tour_stock_date_second = create(:tour_stock_date, subvariacao: '02/02/2002')
    tour_stock_date_first = create(:tour_stock_date, subvariacao: '01/01/1001')

    expect( TourStockDate.display.first ).to eq tour_stock_date_first
    expect( TourStockDate.display.second ).to eq tour_stock_date_second
  end

  it 'finds options avaiable on specific date' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")
    different_date_str = (selected_date + 2.days).strftime("%d/%m/%Y")

    tour_stock_date_yes = create(:tour_stock_date, status: 'Ativo', subvariacao: selected_date_str)
    tour_stock_date_no = create(:tour_stock_date, status: 'Ativo', subvariacao: different_date_str)

    expect( TourStockDate.count ).to eq 2
    expect( TourStockDate.available_on_date(selected_date).count ).to eq 1
    expect( TourStockDate.available_on_date(selected_date).first ).to eq tour_stock_date_yes
  end

  it 'considers status in options avaiable' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour_stock_date_yes = create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo')
    tour_stock_date_no = create(:tour_stock_date, subvariacao: selected_date_str, status: 'Excluido')

    expect( TourStockDate.count ).to eq 2
    expect( TourStockDate.available_on_date(selected_date).count ).to eq 1
    expect( TourStockDate.available_on_date(selected_date).first ).to eq tour_stock_date_yes
  end

  it 'considers stock quantity in options avaiable' do
    selected_date = Date.current
    selected_date_str = selected_date.strftime("%d/%m/%Y")

    tour_stock_date_yes = create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', estoque: 1)
    tour_stock_date_no = create(:tour_stock_date, subvariacao: selected_date_str, status: 'Ativo', estoque: 0)

    expect( TourStockDate.count ).to eq 2
    expect( TourStockDate.available_on_date(selected_date).count ).to eq 1
    expect( TourStockDate.available_on_date(selected_date).first ).to eq tour_stock_date_yes
  end
end
