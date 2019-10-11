# frozen_string_literal: true

require 'rails_helper'

feature 'person sees event' do
  scenario 'in English' do
    institutional = create(:institutional, tag: 'eventos')
    create(:institutional_locale, institutional: institutional)
    event = create(:event, start_date: '2018-03-19', end_date: Date.current, number_participants: 7538)
    create(:event_locale, event: event, name: 'Fun Big Party')

    visit root_en_path

    click_on 'Fun Big Party'

    expect(page).to have_css("img[src*='banner.png']")
    expect(page).to have_css 'h1', text: 'Fun Big Party'
    expect(page).to have_content '19 Mar 2018'
    expect(page).to have_content 7538
  end

  scenario 'in Portuguese' do
    institutional = create(:institutional, tag: 'eventos')
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR')
    event = create(:event, start_date: '19/03/2018', end_date: Date.current, number_participants: 7538)
    create(:event_locale, event: event, name: 'Eventão massa!', locale: 'pt-BR')

    visit root_path

    click_on 'Eventão massa!'

    expect(page).to have_css("img[src*='banner.png']")
    expect(page).to have_css 'h1', text: 'Eventão massa!'
    expect(page).to have_content '19/03/2018'
    expect(page).to have_content 7538
  end
end
