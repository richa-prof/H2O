# frozen_string_literal: true

require 'rails_helper'

feature 'person sees add to cart buttons' do
  scenario 'in Portuguese' do
    visit add_to_cart_carts_pt_br_path

    expect(page).to have_link 'Acrescentar Passeios', href: tours_pt_br_path
    expect(page).to have_link 'Acrescentar Hospedagem', href: hotels_pt_br_path
  end

  scenario 'in English' do
    visit add_to_cart_carts_en_path

    expect(page).to have_link 'Add Tours', href: tours_en_path
    expect(page).to have_link 'Add Lodging', href: hotels_en_path
  end
end
