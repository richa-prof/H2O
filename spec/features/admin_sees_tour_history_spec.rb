# frozen_string_literal: true

require 'rails_helper'

feature 'admin sees tour history' do
  scenario 'sucessfully' do
    this_admin = create(:admin, email: 'this-admin@email.com')
    create(:tour, nome: 'Primeiro Nome', link: 'primeiro-link', localidade: 'Bonito MS')

    log_admin_in this_admin

    visit '/interno'
    click_on_admin_menu
    click_on 'Passeios'
    click_on 'Editar'

    fill_in 'Nome', with: 'Segundo Nome'
    fill_in 'Link', with: 'segundo-link'
    rails_admin_select 'Campo Grande MS', 'tour_localidade_field'

    click_on 'Salvar e voltar para a lista'
    click_on 'Histórico'

    within 'table#history' do
      expect(page).to have_content 'this-admin@email.com'
      expect(page).to have_content Date.current.strftime '%d/%m/%Y'

      expect(page).to have_content 'Primeiro Nome'
      expect(page).to have_content 'Segundo Nome'

      expect(page).to have_content 'primeiro-link'
      expect(page).to have_content 'segundo-link'

      expect(page).to have_content 'Bonito MS'
      expect(page).to have_content 'Campo Grande MS'
    end
  end
end
