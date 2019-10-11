# frozen_string_literal: true

require 'rails_helper'

feature 'person accesses blog post' do
  scenario 'with full link' do
    visit '/pt-br/blog/2954639589117494271/lista--distancias-passeios-em-bonito-ms'

    expect(page).to have_title 'Blog H2O - Lista das distâncias em Bonito – MS – Brasil'

    within 'section.blogdetails-bg' do
      expect(page).to have_content 'Lista das distâncias em Bonito – MS – Brasil'
    end
  end

  scenario 'with post id only' do
    visit '/pt-br/blog/2954639589117494271/'

    within 'section.blogdetails-bg' do
      expect(page).to have_content 'Lista das distâncias em Bonito – MS – Brasil'
    end
  end
end
