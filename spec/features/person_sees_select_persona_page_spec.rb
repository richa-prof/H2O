# frozen_string_literal: true

require 'rails_helper'

feature 'person sees select persona page' do
  scenario 'sucessfully' do
    persona_1 = create(:persona, link: 'turista-feliz')
    create(:persona_locale, persona: persona_1, locale: 'pt-BR', nome: 'Turista Feliz')

    persona_2 = create(:persona, link: 'alguem-legal')
    create(:persona_locale, persona: persona_2, locale: 'pt-BR', nome: 'Alguém Legal')

    visit root_path

    click_on 'Menu'
    sleep 0.5

    within 'div#collapsibleNavbar' do
      click_on 'Sugestões de Roteiro'
    end

    expect(page).to have_content 'O ROTEIRO IDEAL PARA VOCÊ EM BONITO MS'

    expect(page).to have_content 'Turista Feliz'
    expect(page).to have_link(nil, href: persona_persona_day_by_days_path(persona_1))

    expect(page).to have_content 'Alguém Legal'
    expect(page).to have_link(nil, href: persona_persona_day_by_days_path(persona_2))
  end
end
