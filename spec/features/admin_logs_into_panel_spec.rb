# frozen_string_literal: true

require 'rails_helper'

feature 'admin logs into panel' do
  scenario 'sucessfully as Admin' do
    admin_type_admin = create(:admin_type, id: 2, nome: 'Admin')
    admin_type_agent = create(:admin_type, id: 8, nome: 'Agent')
    create(:admin, admin_type: admin_type_admin, email: 'admin@teste.com.br', password: '1234ABCD')

    visit '/interno'

    fill_in 'admin_email', with: 'admin@teste.com.br'
    fill_in 'admin_password', with: '1234ABCD'
    click_on 'Entrar'
    click_on_admin_menu

    expect(page).to have_content 'Agência H2O Interno'
    expect(page).to have_content 'Menu'
    expect(page).to have_content 'Passeios'
    expect(page).to have_content 'Usuários'
  end

  scenario 'sucessfully as Agent' do
    admin_type_admin = create(:admin_type, id: 2, nome: 'Admin')
    admin_type_agent = create(:admin_type, id: 8, nome: 'Agent')
    create(:admin, admin_type: admin_type_agent, email: 'agent@teste.com.br', password: '1234ABCD')

    visit '/interno'

    fill_in 'admin_email', with: 'agent@teste.com.br'
    fill_in 'admin_password', with: '1234ABCD'
    click_on 'Entrar'
    click_on_admin_menu

    expect(page).to have_content 'Agência H2O Interno'
    expect(page).to have_content 'Início'
    expect(page).to have_content 'Sair'
    expect(page).not_to have_content 'Passeios'
    expect(page).not_to have_content 'Usuários'
  end
end
