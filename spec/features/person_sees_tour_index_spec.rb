# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour index' do
  scenario 'in English' do
    tour = create(:tour, imagem_1: 'test_imagem_1.png')
    tour_locale = create(:tour_locale, tour: tour, locale: 'en-US', nome: 'Tour ABC')

    visit '/en/tours'

    expect(page).to have_content 'Tours'
    expect(page).to have_content 'Tour ABC'
    expect(page).to have_css("img[src*='test_imagem_1.png']")
  end

  scenario 'in Portuguese' do
    tour = create(:tour)
    create(:tour_locale, tour: tour, locale: 'pt-BR', nome: 'Passeio ABC')

    visit '/passeios'

    expect(page).to have_content 'Passeios'
    expect(page).to have_content 'Passeio ABC'
  end

  scenario 'with both types of image' do
    tour_image = create(:tour, id: 1, imagem_1: 'test_imagem_1.png')
    create(:tour_locale, :pt_br, tour: tour_image)

    tour_attached = create(:tour, id: 2, imagem_1: 'test_imagem_1.png')
    tour_attached.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')
    create(:tour_locale, :pt_br, tour: tour_attached)

    visit '/passeios'

    within 'div#tour_1' do
      expect(page).to have_css("img[src*='test_imagem_1.png']")
      expect(page).not_to have_css("img[src*='test.png']")
    end
    within 'div#tour_2' do
      expect(page).not_to have_css("img[src*='test_imagem_1.png']")
      expect(page).to have_css("img[src*='test.png']")
    end
  end

  scenario 'with Brazilian prices' do
    tour = create(:tour)
    create(:tour_locale, tour: tour, locale: 'pt-BR')
    create(:tour_price, tour: tour, preco_adulto: 38.99)

    visit '/passeios'

    expect(page).to have_content 'R$ 38,99'
  end

  scenario 'with international prices' do
    tour = create(:tour)
    create(:tour_locale, tour: tour, locale: 'en-US')
    create(:tour_price, tour: tour, preco_adulto: 38.99)

    visit '/en/tours'

    expect(page).to have_content '38.99 BRL'
  end
end
