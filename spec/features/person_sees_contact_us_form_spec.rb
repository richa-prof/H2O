# frozen_string_literal: true

require 'rails_helper'

feature 'person sees contact us form' do
  scenario 'sucessfully' do
    institutional = create(:institutional)
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR', titulo_menu: 'Contato')

    visit root_path
    click_on 'Contato'
    sleep 0.5

    expect(page).to have_selector 'div#site-h2o-basico-b116bf4368612dbd4ff2'
  end
end
