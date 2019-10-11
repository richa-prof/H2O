# frozen_string_literal: true

require 'rails_helper'

feature 'person sees categories index' do
  scenario 'sucessfully' do
    first_category = create(:category, exibir_site: true)
    first_category_locale = create(:category_locale, locale: 'pt-BR', nome: 'Category One')
    create(:cat_locale, category: first_category, category_locale: first_category_locale)

    second_category = create(:category, exibir_site: true)
    second_category_locale = create(:category_locale, locale: 'pt-BR', nome: 'Category Two')
    create(:cat_locale, category: second_category, category_locale: second_category_locale)

    create(:tour, :with_pt_br_locale, localidade: 'Firstville')
    create(:tour, :with_pt_br_locale, localidade: 'Secondton')

    visit root_path
    click_on 'Categorias'

    within 'div.category-list' do
      expect(page).to have_content 'Category One'
      expect(page).to have_content 'Category Two'
    end

    expect(page).to have_content 'Firstville'
    expect(page).to have_content 'Secondton'
  end
end
