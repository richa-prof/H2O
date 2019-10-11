# frozen_string_literal: true

require 'rails_helper'

feature 'person adds hotel to cart' do
  scenario 'sucessfully' do
    hotel = create(:hotel, :pt_br, hotels_api_code: 5, link: 'this-hotel')

    visit '/hoteis/this-hotel'
    find('a.room-rate', match: :first).click
    find('a#add_to_trip_btn').click

    expect(page).to have_content 'Carrinho'
    expect(page).to have_content hotel.hotel_locales.where(locale: 'pt-BR').first.nome.upcase
    expect(page).to have_content 'LUXO'
    expect(page).to have_content '3 diária(s) por R$ 219,44'
    expect(page).to have_content 'Adultos 2'
    expect(page).to have_content 'Criança 0'
  end
end
