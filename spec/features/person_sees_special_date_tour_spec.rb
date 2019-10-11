# frozen_string_literal: true

require 'rails_helper'

feature 'person sees special date tour' do
  scenario 'sucessfully' do
    today_str = Date.current.strftime("%d/%m/%Y")
    special_date_str = (Date.current + 10.days).strftime("%d/%m/%Y")

    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio', special_date: true)
    tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo')
    create(:tour_stock_date, tour_stock_time: tour_stock_time, status: 'Ativo', subvariacao: special_date_str)

    visit '/passeios/este-passeio'

    expect(page).to have_field 'selected_date', with: special_date_str
    expect(page).not_to have_field 'selected_date', with: today_str
  end
end
