# frozen_string_literal: true

require 'rails_helper'

feature 'person sees FAQ page' do
  scenario 'sucessfully' do
    institutional = create(:institutional)
    create(:institutional_locale, institutional: institutional, locale: 'pt-BR',
                                  titulo_menu: 'Dúvidas Frequentes',
                                  titulo: 'Encontre Respostas')
    create(:question, institutional: institutional, locale: 'pt-BR',
                      titulo: 'Você programa em HTML?')
    create(:question, institutional: institutional, locale: 'en-US',
                      titulo: 'Do you program in HTML?')

    visit root_path
    click_on 'Dúvidas Frequentes'

    expect(page).to have_css 'h1', text: 'DÚVIDAS FREQUENTES'
    expect(page).to have_css 'h2', text: 'Encontre Respostas'
    expect(page).to have_css 'h3', text: 'Você programa em HTML?'
    expect(page).not_to have_css 'h3', text: 'Do you program in HTML?'
  end

  scenario 'sucessfully' do
    institutional = create(:institutional)
    create(:institutional_locale, institutional: institutional, locale: 'en-US',
                                  titulo_menu: 'FAQ',
                                  titulo: 'Find Answers')
    create(:question, institutional: institutional, locale: 'pt-BR',
                      titulo: 'Você programa em HTML?')
    create(:question, institutional: institutional, locale: 'en-US',
                      titulo: 'Do you program in HTML?')

    visit '/en'
    click_on 'FAQ'

    expect(page).to have_css 'h1', text: 'FAQ'
    expect(page).to have_css 'h2', text: 'Find Answers'
    expect(page).to have_css 'h3', text: 'Do you program in HTML?'
    expect(page).not_to have_css 'h3', text: 'Você programa em HTML?'
  end
end
