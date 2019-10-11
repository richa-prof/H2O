# frozen_string_literal: true

require 'rails_helper'

feature 'admin sees search history' do
  scenario 'sucessfully' do
    create(:search_history, searched_term: 'something')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Históricos de Busca'

    expect(page).to have_content 'something'
  end
end
