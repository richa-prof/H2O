# frozen_string_literal: true

require 'rails_helper'

feature 'admin sees admin' do
  scenario 'sucessfully' do
    create(:admin, nome: 'Humberto da Silva Sauro', meta: 150)
    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Usuários'

    tr_to_focus_on = find('td', :text => 'Humberto da Silva Sauro').find(:xpath, '..')

    within tr_to_focus_on do
      click_on 'Ver'
    end

    expect(page).to have_content 'Humberto da Silva Sauro'
    expect(page).to have_content 'R$ 150,00'
  end
end
