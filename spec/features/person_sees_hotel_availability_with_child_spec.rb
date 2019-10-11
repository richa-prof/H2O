# frozen_string_literal: true

require 'rails_helper'

feature 'person sees hotel availability with child' do
  scenario 'sucessfully' do
    create(:hotel, :pt_br, hotels_api_code: 5, link: 'this-hotel')

    visit '/hoteis/this-hotel'

    fill_in 'Entrada', with: '09/11/2019'
    fill_in 'Saída', with: '11/11/2019'
    fill_in 'Adultos', with: 2

    fill_in 'Crianças', with: 1
    page.execute_script %Q{ $('input#children').trigger('change') }
    fill_in 'Idade', with: 9

    click_on 'Atualizar'

    expect(page).to have_content '2 diária(s)'
    expect(page).to have_content 'R$ 282,50'
    expect(page).to have_content 'R$ 409,50'
  end
end
