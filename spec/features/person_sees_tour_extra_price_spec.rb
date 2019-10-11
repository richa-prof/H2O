# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour extra price' do
  scenario 'sucessfully' do
    tour = create(:tour, :pt_br_with_price, link: 'este-passeio')
    tour_extra_price_type = create(:tour_extra_price_type, :person_pt_br)
    tour_extra = create(:tour_extra, :pt_br, tour: tour, tour_extra_price_type: tour_extra_price_type)

    in_the_past = Date.current - 5.months
    in_the_future = Date.current + 5.months

    create(:tour_extra_price, tour_extra: tour_extra, inicio: '01/01/1900', fim: in_the_past, preco_adulto: 50)
    create(:tour_extra_price, tour_extra: tour_extra, inicio: '01/01/1900', fim: in_the_future, preco_adulto: 1)

    visit '/passeios/este-passeio'
    find('a.tour_time').click

    within 'div#tour_extras' do
      expect(page).to have_content 'R$ 1,00'

      expect(page).not_to have_content '50'
    end
  end
end
