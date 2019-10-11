# frozen_string_literal: true

require 'rails_helper'

feature 'person adds tour stock to cart' do
  scenario 'sucessfully' do
    tour_date = Date.current.strftime("%d/%m/%Y")

    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio', cdgbtms_atrativo: '', cdgbtms_atividade: '')
    create(:tour_price, tour: tour)

    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo')
    create(:tour_stock_date, tour_stock_time: tour_stock_time, status: 'Ativo', subvariacao: tour_date)

    visit '/passeios/este-passeio'

    find('a.tour_time').click

    find('button[data-field="adults"][data-type="plus"]').click

    find('a#add_to_trip_btn').click

    expect(page).to have_content 'Carrinho'
    expect(page).to have_content tour.tour_locales.where(locale: 'pt-BR').first.nome.upcase
    expect(page).to have_content tour_date
  end
end
