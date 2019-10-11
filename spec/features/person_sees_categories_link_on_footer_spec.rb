# frozen_string_literal: true

require 'rails_helper'

feature 'person sees categories link on footer' do
  scenario 'sucessfully' do
    visit root_path

    within 'footer' do
      expect(page).to have_link 'Categorias', href: categories_path
    end
  end
end
