# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new institutional locale' do
  scenario 'sucessfully' do
    create(:institutional, tag: 'this', titulo: 'that')
    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Institucionais (Idiomas)'
    click_on 'Novo(a)'

    rails_admin_select 'this - that', 'institutional_locale_institucionai_id_field'
    rails_admin_select 'pt-BR', 'institutional_locale_locale_field'

    fill_in 'Título da Página', with: 'Read this!'
    fill_in 'Título no Menu', with: 'Important'
    fill_in 'Metatag Título', with: 'Something important to read'
    fill_in 'Metatag Descrição', with: 'Description of what is important.'
    fill_in 'Conteúdo', with: 'Detailed information that is important.'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Institucional (Idiomas) criado com sucesso'
    expect(page).to have_content 'pt-BR'
    expect(page).to have_content 'Read this!'
    expect(page).to have_content 'Important'
  end
end
