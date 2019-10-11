# frozen_string_literal: true

require 'rails_helper'

feature 'admin uploads new banner image' do
  scenario 'sucessfully' do
    create(:banner)

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Banners'
    click_on 'Editar'

    attach_file 'Image', Rails.root.join('spec/support/test.png')

    click_on 'Salvar e voltar para a lista'
    click_on 'Ver'

    expect(page).to have_css "img[src*='test.png']"
  end
end
