# frozen_string_literal: true

require 'rails_helper'

feature 'person sees oferta index' do
  scenario 'sucessfully' do
    special_deal = create(:special_deal, name: 'WOW!')

    visit '/ofertas'

    expect(page).to have_content 'Ofertas'
    expect(page).to have_content 'WOW!'
  end
end
