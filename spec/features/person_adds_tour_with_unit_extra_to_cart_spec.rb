# frozen_string_literal: true

require 'rails_helper'

feature 'person adds tour with unit extra to cart' do
  scenario 'sucessfully' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    create(:tour_price, tour: tour, preco_adulto: 25.25)

    tour_extra_price_type = create(:tour_extra_price_type, :unit_pt_br)
    tour_extra = create(:tour_extra, :pt_br, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_price, tour_extra: tour_extra, preco_unidade: 340)

    tour_date = (Date.current + 3.days).strftime('%d/%m/%Y')

    visit '/passeios/este-passeio'

    page.execute_script("$('#selected_date').datepicker('setDate', '#{tour_date}')")

    find('a.tour_time').click

    find('button[data-field="adults"][data-type="plus"]').click
    find('button[data-field="extra_unit_1"][data-type="plus"]').click

    find('a#add_to_trip_btn').click

    expect(page).to have_content 'Carrinho'
    expect(page).to have_content tour.tour_locales.where(locale: 'pt-BR').first.nome.upcase
    expect(page).to have_content tour_date
    expect(page).to have_content tour_extra.tour_extra_locales.where(locale: 'pt-BR').first.titulo
    expect(page).to have_content 'R$ 365,25'
  end

  scenario 'sucessfully' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    create(:tour_price, tour: tour, preco_adulto: 25.25)

    tour_extra_price_type = create(:tour_extra_price_type, :unit_pt_br)
    tour_extra = create(:tour_extra, :pt_br, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_price, tour_extra: tour_extra, preco_unidade: 340)

    tour_date = (Date.current + 3.days).strftime('%d/%m/%Y')

    visit '/passeios/este-passeio'

    page.execute_script("$('#selected_date').datepicker('setDate', '#{tour_date}')")

    find('a.tour_time').click

    find('button[data-field="adults"][data-type="plus"]').click
    find('button[data-field="extra_unit_1"][data-type="plus"]').click
    find('button[data-field="extra_unit_1"][data-type="plus"]').click

    find('a#add_to_trip_btn').click

    expect(page).to have_content 'R$ 705,25'
  end
end
