# frozen_string_literal: true

require 'rails_helper'

feature 'admin sees logs' do
  scenario 'sucessfully' do
    create(:my_very_own_log, info: 'Something worth recording.')

    log_admin_in

    visit '/interno'
    click_on_admin_menu
    click_on 'Logs'

    expect(page).to have_content 'Something worth recording.'
  end
end
