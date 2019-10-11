# frozen_string_literal: true

require 'rails_helper'

feature 'person sees hotel' do
  scenario 'sucessfully en' do
    hotel = create(:hotel, imagem_1: 'test_imagem_1.png')
    create(:hotel_locale, hotel: hotel, locale: 'en-US', nome: 'Shady Inn', descricao: 'Beds.')

    visit '/en/hotels'
    click_on 'See More'

    expect(page).to have_css("img[src*='test_imagem_1.png']")

    expect(page).to have_content 'Shady Inn'
    expect(page).to have_content 'Beds.'
  end

  scenario 'sucessfully pt-BR' do
    hotel = create(:hotel, imagem_1: 'test_imagem_1.png')
    create(:hotel_locale, :pt_br, hotel: hotel, nome: 'Lugarzinho', descricao: 'Cama!')

    visit '/hoteis'
    click_on 'Ver mais'

    expect(page).to have_css("img[src*='test_imagem_1.png']")

    expect(page).to have_content 'Lugarzinho'
    expect(page).to have_content 'Cama!'
  end

  scenario 'with attached images' do
    hotel_attached = create(:hotel, imagem_1: 'test_imagem_1.png')
    create(:hotel_locale, :pt_br, hotel: hotel_attached)

    hotel_attached.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')
    hotel_attached.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test2.png')), filename: 'test2.png', content_type: 'image/png')

    visit '/hoteis'
    click_on 'Ver mais'

    expect(page).to have_css("img[src*='test_imagem_1.png']")
    expect(page).to have_css("img[src*='test.png']")
    expect(page).to have_css("img[src*='test2.png']")
  end

  scenario 'that is set to hidden' do
    create(:hotel, :pt_br, link: 'this-hotel', exibir_site: false)

    visit '/hoteis/this-hotel'

    expect(page).to have_content 'You are being redirected.'
  end
end
