# frozen_string_literal: true

require 'rails_helper'

feature 'admin logs into panel' do
  scenario 'sucessfully' do
    log_admin_in

    visit '/interno'
    click_on 'Sair'

    expect(page).to have_content :all, 'Saiu com sucesso.'
  end
end
