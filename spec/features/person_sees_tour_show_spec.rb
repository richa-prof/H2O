# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour show' do
  scenario 'in English' do
    tour = create(:tour, imagem_1: 'test_imagem_1.png')
    create(:tour_locale, tour: tour, locale: 'en-US',
                                     nome: 'Tour ABC',
                                     descricao: 'Explain'
                                    )

    visit '/en/tours'
    click_on 'Buy Now'

    expect(page).to have_content 'Tour ABC'
    expect(page).to have_css("img[src*='test_imagem_1.png']")
    expect(page).to have_content 'Explain'
  end

  scenario 'in Portuguese' do
    create(:tour_locale, :pt_br, nome: 'Passeio ABC', descricao: 'Explain')

    visit '/passeios'
    click_on 'Compre Já'

    expect(page).to have_content 'Passeio ABC'
    expect(page).to have_content 'Explain'
  end

  scenario 'with attached image' do
    tour = create(:tour, imagem_1: 'test_imagem_1.png')
    tour.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')
    create(:tour_locale, :pt_br, tour: tour)

    visit '/passeios'
    click_on 'Compre Já'

    expect(page).to have_css("img[src*='test_imagem_1.png']")
    expect(page).to have_css("img[src*='test.png']")
  end
end
