# frozen_string_literal: true

require 'rails_helper'

feature 'person sees banners' do
  scenario 'sucessfully' do
    create(:banner, :with_locales, imagem: 'this_banner.jpg')

    visit root_path

    expect( find('section.banner-bg')['innerHTML'] ).to include 'this_banner.jpg'
  end

  scenario 'attached image only' do
    banner_attached = create(:banner, :with_locales, imagem: 'this_banner.jpg')
    banner_attached.image.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')

    visit root_path

    expect( find('section.banner-bg')['innerHTML'] ).to include 'test.png'
    expect( find('section.banner-bg')['innerHTML'] ).not_to include 'this_banner.jpg'
  end
end
