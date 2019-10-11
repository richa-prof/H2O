# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour prices' do
  scenario 'sucessfully' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    create(:tour_price, tour: tour, inicio: '01/07/3020', fim: '31/12/3020', preco_adulto: 50)
    create(:tour_price, tour: tour, inicio: '01/07/3020', fim: '31/12/3020', preco_adulto: 200)

    visit '/passeios/este-passeio'
    page.execute_script("$('#selected_date').datepicker('setDate', '01/08/3020')")

    within 'div#tour_price' do
      expect(page).to have_content 'R$ 200,00'
      expect(page).not_to have_content '50'
    end
  end

  scenario 'for another date' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    create(:tour_price, tour: tour, inicio: '01/07/3020', fim: '31/12/3020', preco_adulto: 50)
    create(:tour_price, tour: tour, inicio: '01/07/3025', fim: '31/12/3025', preco_adulto: 200)

    visit '/passeios/este-passeio'
    page.execute_script("$('#selected_date').datepicker('setDate', '01/08/3020')")
    wait_for_ajax
    page.execute_script("$('#selected_date').datepicker('setDate', '01/08/3025')")
    wait_for_ajax

    within 'div#tour_price' do
      expect(page).to have_content 'R$ 200,00'
      expect(page).not_to have_content '50'
    end
  end

  scenario 'for a date with no prices' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')
    create(:tour_price, tour: tour, inicio: '01/07/3020', fim: '31/12/3020', preco_adulto: 50)

    visit '/passeios/este-passeio'

    page.execute_script("$('#selected_date').datepicker('setDate', '01/08/3020')")
    wait_for_ajax
    page.execute_script("$('#selected_date').datepicker('setDate', '01/08/3025')")
    wait_for_ajax

    within 'div.trip-box' do
      expect(page).not_to have_content 'R$'
      expect(page).not_to have_content '50'
    end
  end
end
