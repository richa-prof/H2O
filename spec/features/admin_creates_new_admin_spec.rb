# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new admin' do
  scenario 'sucessfully' do
    create(:admin_type, nome: 'Um Perfil Qualquer')
    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Usuários'
    click_on 'Novo(a)'

    rails_admin_select 'Um Perfil Qualquer', 'admin_adm_usuario_perfil_id_field'
    fill_in 'Nome', with: 'Um Usuário Novinho'
    fill_in 'E-mail', with: 'meu.novo.admin@teste.com.br'
    fill_in 'Usuário', with: 'novo'
    rails_admin_select 'Bonito', 'admin_base_field'
    fill_in 'Senha', with: 'ABCD1234'
    fill_in 'Meta', with: 150
    fill_in 'Whats', with: '+55 (11) 2233-4455'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Usuário criado com sucesso'
    expect(page).to have_content 'Um Usuário Novinho'
  end

  scenario 'repeating an e-mail' do
    admin_type = create(:admin_type, nome: 'Um Perfil Qualquer')
    create(:admin, admin_type: admin_type, email: 'the.same@email.com')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Usuários'
    click_on 'Novo(a)'

    rails_admin_select 'Um Perfil Qualquer', 'admin_adm_usuario_perfil_id_field'
    fill_in 'Nome', with: 'nome'
    fill_in 'E-mail', with: 'the.same@email.com'
    fill_in 'Usuário', with: 'usuario'
    rails_admin_select 'Bonito', 'admin_base_field'
    fill_in 'Senha', with: 'senha123'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Usuário NÃO foi criado'
    expect(page).to have_content 'E-mail já está em uso'
  end

  scenario 'repeating a username' do
    admin_type = create(:admin_type, nome: 'Um Perfil Qualquer')
    create(:admin, admin_type: admin_type, usuario: 'SameUser')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Usuários'
    click_on 'Novo(a)'

    rails_admin_select 'Um Perfil Qualquer', 'admin_adm_usuario_perfil_id_field'
    fill_in 'Nome', with: 'nome'
    fill_in 'E-mail', with: 'some.random@e-mail.com'
    fill_in 'Usuário', with: 'SameUser'
    rails_admin_select 'Bonito', 'admin_base_field'
    fill_in 'Senha', with: 'senha123'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Usuário NÃO foi criado'
    expect(page).to have_content 'Usuário WOW já está em uso'
  end
end
