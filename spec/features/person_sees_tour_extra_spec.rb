# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour extra' do
  scenario 'sucessfully' do
    tour = create(:tour, :pt_br_with_price, link: 'este-passeio')
    tour_extra_price_type = create(:tour_extra_price_type, :person_pt_br)

    tour_extra_no_price = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_locale, :pt_br, tour_extra: tour_extra_no_price, titulo: 'No price. Hide me.')

    tour_extra_expired = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_locale, :pt_br, tour_extra: tour_extra_expired, titulo: 'Expired price. Hide me, too.')

    tour_extra_wrong_locale = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_locale, tour_extra: tour_extra_wrong_locale, titulo: 'I wrong locale.')

    tour_extra_all_right = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_locale, :pt_br, tour_extra: tour_extra_all_right, titulo: 'The right one! Show the world!')

    in_the_past = Date.current - 5.months
    in_the_future = Date.current + 5.months

    create(:tour_extra_price, tour_extra: tour_extra_expired, inicio: '01/01/1900', fim: in_the_past)
    create(:tour_extra_price, tour_extra: tour_extra_wrong_locale, inicio: '01/01/1900', fim: in_the_future)
    create(:tour_extra_price, tour_extra: tour_extra_all_right, inicio: '01/01/1900', fim: in_the_future)

    visit '/passeios/este-passeio'
    find('a.tour_time').click

    within 'div#tour_extras' do
      expect(page).to have_content 'The right one! Show the world!'

      expect(page).not_to have_content 'No price. Hide me.'
      expect(page).not_to have_content 'Expired price. Hide me, too.'
      expect(page).not_to have_content 'I wrong locale.'
    end
  end
end
