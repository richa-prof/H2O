# frozen_string_literal: true

require 'rails_helper'

feature 'person sees create account page' do
  scenario 'sucessfully' do
    visit root_path

    click_on 'Menu'
    sleep 0.5
    click_on 'Entrar / Criar Conta'

    within 'div#login_side' do
      expect(page).to have_content 'ENTRAR'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'Senha'
      expect(page).to have_content 'Esqueceu a senha?'
      expect(page).to have_content 'Não recebeu as informações de confirmação?'
    end

    within 'div#register_side' do
      expect(page).to have_content 'CRIAR CONTA'
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'Senha'
      expect(page).to have_content 'Confirmar Senha'
    end
  end
end
