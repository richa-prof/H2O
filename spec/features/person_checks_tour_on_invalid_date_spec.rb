# frozen_string_literal: true

require 'rails_helper'

feature 'person checks tour on invalid date' do
  scenario 'number' do
    create(:tour, :with_pt_br_locale, link: 'este-passeio')

    visit '/passeios/este-passeio'
    page.execute_script("$('#selected_date').datepicker('setDate', '3025')")
    wait_for_ajax

    expect(page).to have_field 'selected_date', with: Date.current.strftime('%d/%m/%Y')
    expect(page).to have_content '11:00'
  end

  scenario 'letters' do
    create(:tour, :with_pt_br_locale, link: 'este-passeio')

    visit '/passeios/este-passeio'
    page.execute_script("$('#selected_date').datepicker('setDate', 'xyz')")
    wait_for_ajax

    expect(page).to have_field 'selected_date', with: Date.current.strftime('%d/%m/%Y')
    expect(page).to have_content '11:00'
  end
end
