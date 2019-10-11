# frozen_string_literal: true

require 'rails_helper'

feature 'person creates account' do
  scenario 'sucessfully' do
    build_empty_session_cart

    visit root_path
    click_on 'Menu'
    sleep 0.5

    within 'div#collapsibleNavbar' do
      find('a#login_sign_up').click
    end

    find('div#register_side')

    within 'div#register_side' do
      fill_in 'user_nome', with: 'Meu Nome'
      fill_in 'user_email', with: 'meu.email@email.com'
      fill_in 'user_password', with: 'abcd1234'
      fill_in 'user_password_confirmation', with: 'abcd1234'

      click_on 'Criar Conta'
    end

    expect(page).to have_content 'Acrescentar ao Roteiro'
  end
end
