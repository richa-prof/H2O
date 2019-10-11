# frozen_string_literal: true

require 'rails_helper'

feature 'person sees home special deals' do
  scenario 'sucessfully' do
    create(:special_deal, :pt_br, photo_home: 'home.jpg')

    visit root_path

    within 'section.specialdeals-bg' do
      expect(page).to have_css "img[src*='home.jpg']"
    end
  end

  scenario 'attached image only' do
    special_deal_attached = create(:special_deal, :pt_br, photo_home: 'home.jpg')
    special_deal_attached.thumbnail_image.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')

    visit root_path

    within 'section.specialdeals-bg' do
      expect(page).to have_css "img[src*='test.png']"
      expect(page).not_to have_css "img[src*='home.jpg']"
    end
  end
end
