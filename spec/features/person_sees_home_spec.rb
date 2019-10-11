# frozen_string_literal: true

require 'rails_helper'

feature 'person sees home' do
  scenario 'tours in Portuguese' do
    tour_image = create(:tour, id: 1, imagem_1: 'test_imagem_1.png')
    create(:tour_locale, :pt_br, tour: tour_image, nome: 'Name of Tour Image')

    tour_attached = create(:tour, id: 2, imagem_1: 'test_imagem_1.png')
    tour_attached.images.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')
    create(:tour_locale, :pt_br, tour: tour_attached, nome: 'Name of Tour Attached')

    visit '/'

    within 'section.tours-bg' do
      expect(page).to have_content 'PASSEIOS'

      within 'div#tour_1' do
        expect(page).to have_content 'Name of Tour Image'
        expect(page).to have_css("img[src*='test_imagem_1.png']")
        expect(page).not_to have_css("img[src*='test.png']")
      end

      within 'div#tour_2' do
        expect(page).to have_content 'Name of Tour Attached'
        expect(page).not_to have_css("img[src*='test_imagem_1.png']")
        expect(page).to have_css("img[src*='test.png']")
      end
    end
  end

  scenario 'events' do
    event_yes = create(:event, end_date: Date.current)
    create(:event_locale, event: event_yes, name: 'Eventão massa!', locale: 'pt-BR')

    event_no = create(:event, end_date: Date.current - 2.days)
    create(:event_locale, event: event_no, name: 'Me esconda, please!', locale: 'pt-BR')

    visit '/'

    expect(page).to have_content 'Eventão massa!'
    expect(page).not_to have_content 'Me esconda, please!'
  end
end
