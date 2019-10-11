# frozen_string_literal: true

require 'rails_helper'

feature 'person sees staff page' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'equipe')
    create(:institutional_locale, institutional: institutional, titulo_menu: 'H2O Staff', titulo: 'Meet the Staff')
    staff = create(:staff, institutional: institutional, nome: 'Lewis Litt')
    create(:staff_locale, staff: staff, cargo: 'Summer Associate')

    visit '/en/institutional/equipe'

    expect(page).to have_content 'Meet the Staff'
    expect(page).to have_content 'Lewis Litt'
    expect(page).to have_content 'Summer Associate'
    expect( find('div.images')['innerHTML'] ).to include 'test_imagem_1'
  end
end
