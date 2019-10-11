# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new banner' do
  scenario 'sucessfully' do
    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Banners'
    click_on 'Novo(a)'

    fill_in 'Ordem', with: 3
    fill_in 'Tema', with: 'Something fun'

    attach_file 'Image', Rails.root.join('spec/support/test.png')

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Banner criado com sucesso'
    expect(page).to have_content '3 Something fun'
  end
end
