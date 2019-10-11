# frozen_string_literal: true

require 'rails_helper'

feature 'admin uploads new hotel image' do
  scenario 'sucessfully' do
    create(:hotel)

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Hotéis'
    click_on 'Editar'

    attach_file 'Imagens', Rails.root.join('spec/support/test.png')

    click_on 'Salvar e voltar para a lista'
    click_on 'Ver'

    expect(page).to have_css "img[src*='test.png']"
  end
end
