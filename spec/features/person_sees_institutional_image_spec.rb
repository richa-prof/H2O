# frozen_string_literal: true

require 'rails_helper'

feature 'person sees institutional show' do
  scenario 'sucessfully' do
    institutional_locale = create(:institutional_locale, :pt_br, titulo_menu: 'This Page')
    institutional_locale.image.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')

    visit root_path
    click_on 'This Page'

    expect(page).to have_css("img[src*='test.png']")
  end
end
