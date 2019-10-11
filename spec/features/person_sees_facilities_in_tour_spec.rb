# frozen_string_literal: true

require 'rails_helper'

feature 'person sees facilities in tour' do
  scenario 'sucessfully en' do
    tour = create(:tour, :with_locale, link: 'this-tour')
    facility = create(:facility)
    tour_facility = create(:tour_facility, tour: tour, facility: facility)

    visit '/en/tours/this-tour'

    within 'div#facilities' do
      expect(page).to have_css("img[src*='#{facility.icon_name}-icon']")
      expect(page).to have_content facility.facility_locales.where('locale = ?', 'en-US').first.nome
    end
  end

  scenario 'sucessfully pt-BR' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    facility = create(:facility)
    tour_facility = create(:tour_facility, tour: tour, facility: facility)

    visit '/passeios/este-passeio'

    within 'div#facilities' do
      expect(page).to have_css("img[src*='#{facility.icon_name}-icon']")
      expect(page).to have_content facility.facility_locales.where(locale: 'pt-BR').first.nome
    end
  end
end
