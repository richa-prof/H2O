# frozen_string_literal: true

require 'rails_helper'

feature 'person sees evento index' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'eventos')
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR')
    create(:event_locale, name: 'Eventão massa!', locale: 'pt-BR')

    visit '/eventos'

    expect(page).to have_content 'Eventos'
    expect(page).to have_content 'Eventão massa!'
    expect( find('div.img')['innerHTML'] ).to include 'banner'
  end
end
