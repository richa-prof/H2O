# frozen_string_literal: true

require 'rails_helper'

feature 'user updates account information' do
  scenario 'sucessfully' do
    login_as create(:user)

    visit root_path
    click_on 'Menu'
    sleep 0.5

    within 'div#collapsibleNavbar' do
      find('a#client_area').click
    end

    find('input#user_nome').set('Meu Nome')
    click_on 'Atualizar informações'

    expect(page).to have_content 'Sua conta foi atualizada com sucesso.'
  end
end
