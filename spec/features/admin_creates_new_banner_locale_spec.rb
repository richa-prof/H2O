# frozen_string_literal: true

require 'rails_helper'

feature 'admin creates new banner locale' do
  scenario 'sucessfully' do
    create(:banner, tipo: 'I am a banner')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Banners (Idiomas)'
    click_on 'Novo(a)'

    rails_admin_select 'I am a banner', 'banner_locale_banner_id_field'
    rails_admin_select 'pt-BR', 'banner_locale_locale_field'
    fill_in 'Título', with: 'Das Banner'
    fill_in 'Subtitulo', with: 'Hear me roar'

    click_on 'Salvar e voltar para a lista'

    expect(page).to have_content 'Banner (Idiomas) criado com sucesso'
    expect(page).to have_content 'I am a banner pt-BR Das Banner Hear me roar'
  end
end
