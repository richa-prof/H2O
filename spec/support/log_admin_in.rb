# frozen_string_literal: true

def log_admin_in admin_to_use = create(:admin, email: 'admin@teste.com.br', password: '1234ABCD')
  visit '/interno'

  fill_in 'admin_email', with: admin_to_use.email
  fill_in 'admin_password', with: admin_to_use.password

  click_on 'Entrar'
end
