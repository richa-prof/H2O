# frozen_string_literal: true

require 'rails_helper'

feature 'person sees stocked tour times' do
  scenario 'sucessfully' do
    date_to_use = Date.current.strftime("%d/%m/%Y")
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio', cdgbtms_atividade: '', cdgbtms_atrativo: '')
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo', variacao: '12:45')
    create(:tour_stock_date, tour_stock_time: tour_stock_time, status: 'Ativo', subvariacao: date_to_use)

    visit '/passeios/este-passeio'

    within 'ul.time' do
      expect(page).to have_content '12:45'
    end
  end
end
