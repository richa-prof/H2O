# frozen_string_literal: true

require 'rails_helper'

feature 'admin sets hotel api id' do
  scenario 'sucessfully' do
    create(:hotel, nome: 'The Love Shack')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Hotéis'
    click_on 'Editar'

    rails_admin_select 'Omnibees Test 1053', 'hotel_hotels_api_code_field'

    click_on 'Salvar e voltar para a lista'
    click_on 'Ver'

    expect(page).to have_content 'Vínculo Hotels API Omnibees Test 1053'
  end
end
