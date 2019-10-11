# frozen_string_literal: true

require 'rails_helper'

feature 'admin uploads new institutional image' do
  scenario 'sucessfully' do
    create(:institutional_locale, :pt_br)

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Institucionais (Idiomas)'
    click_on 'Editar'

    attach_file 'Image', Rails.root.join('spec/support/test.png')

    sleep 5

    click_on 'Salvar e voltar para a lista'
    click_on 'Ver'

    expect(page).to have_css("img[src*='test.png']")
  end
end
