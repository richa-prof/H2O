# frozen_string_literal: true

require 'rails_helper'

feature 'person uses menu search' do
  scenario 'with no info' do
    visit root_path
    click_on 'Menu'

    fill_in 'search_box', with: ''
    page.execute_script("$('#menu_search').submit();")

    within 'section.search-header' do
      expect(page).to have_content 'Encontrados:'
      expect(page).to have_content '0 oferta(s), 0 passeio(s), 0 hotel(éis), e 0 evento(s)'
      expect(page).to have_content 'com o termo ""'
    end
  end

  scenario 'for special deals' do
    special_deal_yes = create(:special_deal, name: 'Crediário', tag_line: 'CVC')
    special_deal_no = create(:special_deal, name: 'different deal')

    visit root_path
    click_on 'Menu'

    fill_in 'search_box', with: 'crediário'
    page.execute_script("$('#menu_search').submit();")

    within 'section.search-header' do
      expect(page).to have_content 'Encontrados: 1 oferta(s)'
    end

    within 'section.search-results' do
      expect(page).to have_content 'Crediário'
      expect(page).to have_content 'CVC'

      expect(page).not_to have_content 'different deal'
    end
  end

  scenario 'for tours' do
    tour_yes = create(:tour)
    create(:tour_locale, :pt_br, tour: tour_yes, nome: 'Magic', metatag_titulo: 'Carpet', metatag_descricao: 'Ride')
    create(:tour_locale, tour: tour_yes, nome: 'different language')

    tour_no = create(:tour)
    create(:tour_locale, :pt_br, tour: tour_no, nome: 'different tour')
    create(:tour_locale, tour: tour_no, nome: 'different tour')

    visit root_path
    click_on 'Menu'

    fill_in 'search_box', with: 'carpet'
    page.execute_script("$('#menu_search').submit();")

    within 'section.search-header' do
      expect(page).to have_content 'Encontrados: 0 oferta(s), 1 passeio(s)'
    end

    within 'section.search-results' do
      expect(page).to have_content 'Magic'
      expect(page).to have_content 'Carpet'
      expect(page).to have_content 'Ride'

      expect(page).not_to have_content 'different language'
      expect(page).not_to have_content 'different tour'
    end
  end

  scenario 'for hotels' do
    hotel_yes = create(:hotel)
    create(:hotel_locale, :pt_br, hotel: hotel_yes, nome: 'Love', metatag_titulo: 'Shack', metatag_descricao: 'Baby')
    create(:hotel_locale, hotel: hotel_yes, nome: 'different language')

    hotel_no = create(:hotel)
    create(:hotel_locale, :pt_br, hotel: hotel_no, nome: 'different hotel')
    create(:hotel_locale, hotel: hotel_no, nome: 'different hotel')

    visit root_path
    click_on 'Menu'

    fill_in 'search_box', with: 'shack'
    page.execute_script("$('#menu_search').submit();")

    within 'section.search-header' do
      expect(page).to have_content 'Encontrados: 0 oferta(s), 0 passeio(s), 1 hotel(éis)'
    end

    within 'section.search-results' do
      expect(page).to have_content 'Love'
      expect(page).to have_content 'Shack'
      expect(page).to have_content 'Baby'

      expect(page).not_to have_content 'different language'
      expect(page).not_to have_content 'different hotel'
    end
  end

  scenario 'for events' do
    event_yes = create(:event)
    create(:event_locale, :pt_br, event: event_yes, name: 'Big', description: 'Party')
    create(:event_locale, event: event_yes, name: 'different language')

    event_no = create(:event)
    create(:event_locale, :pt_br, event: event_no, name: 'different event')
    create(:event_locale, event: event_no, name: 'different event')

    visit root_path
    click_on 'Menu'

    fill_in 'search_box', with: 'big'
    page.execute_script("$('#menu_search').submit();")
    wait_for_ajax

    within 'section.search-header' do
      expect(page).to have_content 'Encontrados: 0 oferta(s), 0 passeio(s), 0 hotel(éis), e 1 evento(s)'
    end

    within 'section.search-results' do
      expect(page).to have_content 'Big'
      expect(page).to have_content 'Party'

      expect(page).not_to have_content 'different language'
      expect(page).not_to have_content 'different event'
    end
  end
end
