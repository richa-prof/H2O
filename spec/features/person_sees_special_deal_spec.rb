# frozen_string_literal: true

require 'rails_helper'

feature 'person sees special deal' do
  scenario 'sucessfully' do
    create(:special_deal, :pt_br, name: 'Promoção Mega Power',
                                  tag_line: 'Esta promoção é mega power.',
                                  descricao: 'Detalhes da promoção.',
                                  photo_page: 'page.jpg')

    visit '/ofertas'
    click_on 'Promoção Mega Power'

    expect(page).to have_css 'section[style*="page.jpg"]'

    expect(page).to have_content 'Promoção Mega Power'
    expect(page).to have_content 'Esta promoção é mega power.'
    expect(page).to have_content 'Detalhes da promoção.'
  end

  scenario 'with attached image' do
    special_deal_attached = create(:special_deal, :pt_br, name: 'Promoção Mega Power', photo_page: 'page.jpg')
    special_deal_attached.background_image.attach(io: File.open(Rails.root.join('spec', 'support', 'test.png')), filename: 'test.png', content_type: 'image/png')

    visit '/ofertas'
    click_on 'Promoção Mega Power'

    expect(page).to have_css 'section[style*="test.png"]'
    expect(page).not_to have_css 'section[style*="page.jpg"]'
  end
end
