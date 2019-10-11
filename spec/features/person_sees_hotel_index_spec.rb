# frozen_string_literal: true

require 'rails_helper'

feature 'person sees hotel index' do
  scenario 'sucessfully en' do
    hotel = create(:hotel)
    hotel_locale = create(:hotel_locale, hotel: hotel, locale: 'en-US', nome: 'Shady Inn')

    visit '/en/hotels'

    expect(page).to have_content 'Hotels'
    expect(page).to have_content 'Shady Inn'
    expect(page).to have_css("img[src*='test_imagem_1.png']")
  end

  scenario 'sucessfully pt-BR' do
    hotel = create(:hotel)
    hotel_locale = create(:hotel_locale, hotel: hotel, locale: 'pt-BR', nome: 'Lugarzinho no Morro')

    visit '/hoteis'

    expect(page).to have_content 'Hotéis'
    expect(page).to have_content 'Lugarzinho no Morro'
    expect(page).to have_css("img[src*='test_imagem_1.png']")
  end

  scenario 'with both types of image' do
    hotel_image = create(:hotel, id: 1, imagem_1: 'test_imagem_1.png')
    create(:hotel_locale, :pt_br, hotel: hotel_image)

    hotel_attached = create(:hotel, id: 2, imagem_1: 'test_imagem_1.png')
    hotel_attached.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')
    create(:hotel_locale, :pt_br, hotel: hotel_attached)

    visit '/hoteis'

    within 'div#hotel_1' do
      expect(page).to have_css("img[src*='test_imagem_1.png']")
      expect(page).not_to have_css("img[src*='test.png']")
    end
    within 'div#hotel_2' do
      expect(page).not_to have_css("img[src*='test_imagem_1.png']")
      expect(page).to have_css("img[src*='test.png']")
    end
  end
end
