# frozen_string_literal: true

require 'rails_helper'

describe TourExtra do
  it 'returns price on selected date' do
    tour_extra = create(:tour_extra)

    create(:tour_extra_price, tour_extra: tour_extra, inicio: '01/01/2001', fim: '10/01/2001', preco_adulto: 1)
    create(:tour_extra_price, tour_extra: tour_extra, inicio: '02/02/2002', fim: '20/02/2002', preco_adulto: 2)
    create(:tour_extra_price, tour_extra: tour_extra, inicio: '02/02/2002', fim: '20/02/2002', preco_adulto: 3)

    expect( tour_extra.check_price( Date.parse('05/01/2001') ).preco_adulto ).to eq 1
    expect( tour_extra.check_price( Date.parse('05/02/2002') ).preco_adulto ).to eq 3
  end
end
