# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new tour' do
  scenario 'sucessfully' do
    create(:lunch, nome: 'Included')
    create(:child, nome: '1 to 5 years old')
    create(:ability, nome: 'Super Fit')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Passeios'
    click_on 'Novo(a)'

    fill_in 'Nome', with: 'Meu Primeiro Passeio'
    fill_in 'Link', with: 'meu-primeiro-passeio'
    rails_admin_select 'Bonito MS', 'tour_localidade_field'
    check 'Exibir Site'
    check 'Status'
    rails_admin_select 'Included', 'tour_almoco_id_field'
    rails_admin_select '1 to 5 years old', 'tour_crianca_id_field'
    rails_admin_select 'Super Fit', 'tour_abilidade_id_field'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Passeio criado com sucesso'
    expect(page).to have_content 'Meu Primeiro Passeio'
  end
end
