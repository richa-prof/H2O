# frozen_string_literal: true

require 'rails_helper'

feature 'person sees category show' do
  scenario 'sucessfully en' do
    first_category = create(:category, :with_locale, link: 'first-category')
    first_tour = create(:tour, :with_locale, imagem_1: 'first.png', localidade: 'First Town')

    second_category = create(:category, :with_locale, link: 'second-category')
    second_tour = create(:tour, :with_locale, imagem_1: 'second.png', localidade: 'Second Town')

    create(:tour_category, tour: first_tour, category: first_category)
    create(:tour_category, tour: second_tour, category: second_category)

    visit '/en/categories/first-category'

    expect(page).to have_css 'h1', text: first_category.category_locales.first.nome.upcase
    expect(page).to have_css("img[src*='first.png']")
    expect(page).to have_content 'First Town'

    within 'div.category-list' do
      expect(page).to have_css 'li.current', text: first_category.category_locales.first.nome
      expect(page).to have_css 'li', text: second_category.category_locales.first.nome
    end

    expect(page).not_to have_css 'h1', text: second_category.category_locales.first.metatag_titulo
    expect(page).not_to have_css("img[src*='second.png']")
    expect(page).not_to have_content 'Second Town'
  end

  scenario 'sucessfully pt-BR' do
    first_category = create(:category, :with_pt_br_locale, link: 'primeira-category')
    first_tour = create(:tour, :with_pt_br_locale, imagem_1: 'primeiro.png', localidade: 'Primeiro Town')

    second_category = create(:category, :with_pt_br_locale, link: 'segunda-category')
    second_tour = create(:tour, :with_pt_br_locale, imagem_1: 'segundo.png', localidade: 'Segundo Town')

    create(:tour_category, tour: first_tour, category: first_category)
    create(:tour_category, tour: second_tour, category: second_category)

    visit '/categorias/primeira-category'

    expect(page).to have_css 'h1', text: first_category.category_locales.first.nome.upcase
    expect(page).to have_css("img[src*='primeiro.png']")
    expect(page).to have_content 'Primeiro Town'

    within 'div.category-list' do
      expect(page).to have_css 'li.current', text: first_category.category_locales.first.nome
      expect(page).to have_css 'li', text: second_category.category_locales.first.nome
    end

    expect(page).not_to have_css 'h1', text: second_category.category_locales.first.metatag_titulo
    expect(page).not_to have_css("img[src*='segundo.png']")
    expect(page).not_to have_content 'Segund0 Town'
  end
end
