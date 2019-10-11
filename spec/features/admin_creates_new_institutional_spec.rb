# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new institutional' do
  scenario 'sucessfully' do
    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Institucionais'
    click_on 'Novo(a)'

    fill_in 'Nome', with: 'Informação Institucional'
    fill_in 'Link', with: 'info-inst'
    check 'Exibir no menu?'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Institucional criado com sucesso'
    expect(page).to have_content 'Informação Institucional'
    expect(page).to have_content 'info-inst'
  end
end
