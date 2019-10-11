# frozen_string_literal: true

require 'rails_helper'

feature 'person sees empty cart' do
  scenario 'successfully' do
    visit '/carrinho/add_to_cart'

    expect(page).to have_content 'Sem Resultados'
  end
end
