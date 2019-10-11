# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour not available' do
  scenario 'sucessfully' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio', cdgbtms_atrativo: '', cdgbtms_atividade: '')

    visit '/passeios/este-passeio'

    within 'div.trip-box' do
      expect(page).to have_content 'PASSEIO SEM DISPONIBILIDADE NA DATA SELECIONADA'
      expect(page).to have_content 'TENTE OUTRA DATA OU FALE COM A NOSSA EQUIPE:'
      expect(page).to have_content 'Disk Passeios:'
      expect(page).to have_content '(67) 9 9860-9808'
      expect(page).to have_content 'E-mail:'
      expect(page).to have_content 'reservas@h2oecoturismo.com.br'
    end
  end
end
