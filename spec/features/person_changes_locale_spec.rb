# frozen_string_literal: true

require 'rails_helper'

feature 'person changes locale' do
  scenario 'to en' do
    visit '/passeios'
    click_on 'Select English'

    expect(page).to have_content 'Tours'
  end

  scenario 'to pt-BR' do
    visit '/en/tours'
    click_on 'Selecionar Português'

    expect(page).to have_content 'Passeios'
  end
end
