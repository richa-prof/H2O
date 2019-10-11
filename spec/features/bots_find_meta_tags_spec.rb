# frozen_string_literal: true

require 'rails_helper'

feature 'bots find meta tags' do
  scenario 'for tours' do
    tour_locale = create(:tour_locale, locale: 'en-US',
                                       metatag_titulo: 'A title for the tour',
                                       metatag_descricao: 'A description of the tour')

    visit '/en/tours'
    click_on 'Buy Now'

    expect(page).to have_title('A title for the tour')
    expect(page).to have_css 'meta[name="description"][content="A description of the tour"]', visible: false
  end

  scenario 'for hotels' do
    hotel_locale = create(:hotel_locale, locale: 'en-US',
                                         metatag_titulo: 'A title for the hotel',
                                         metatag_descricao: 'A description of the hotel')

    visit '/en/hotels'
    click_on 'See More'

    expect(page).to have_title('A title for the hotel')
    expect(page).to have_css 'meta[name="description"][content="A description of the hotel"]', visible: false
  end

  scenario 'for special deals' do
    special_deal = create(:special_deal, name: 'Some crazy prices!')

    visit '/en/special_deals'
    click_on special_deal.name

    expect(page).to have_title('Some crazy prices!')
  end
end
