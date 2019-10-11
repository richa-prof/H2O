# frozen_string_literal: true

require 'rails_helper'

feature 'admin uploads special deal images' do
  scenario 'sucessfully' do
    create(:special_deal)

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Ofertas'
    click_on 'Editar'

    attach_file 'Imagem de Capa', Rails.root.join('spec/support/test.png')
    attach_file 'Imagem de Fundo', Rails.root.join('spec/support/test2.png')

    click_on 'Salvar e voltar para a lista'
    click_on 'Ver'

    expect(page).to have_css "img[src*='test.png']"
    expect(page).to have_css "img[src*='test2.png']"
  end
end
