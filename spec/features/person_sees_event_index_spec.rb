# frozen_string_literal: true

require 'rails_helper'

feature 'person sees event index' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'eventos')
    create(:institutional_locale, institutional: institutional)
    create(:event_locale, name: 'Some cool event!')

    visit '/en/events'

    expect(page).to have_content 'Events'
    expect(page).to have_content 'Some cool event!'
    expect( find('div.img')['innerHTML'] ).to include 'banner'
  end
end
