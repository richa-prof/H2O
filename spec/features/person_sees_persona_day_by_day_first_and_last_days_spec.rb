# frozen_string_literal: true

require 'rails_helper'

feature 'person sees persona day by day first and last days' do
  scenario 'sucessfully' do
    persona = create(:persona, link: 'turista-feliz')
    create(:persona_locale, persona: persona, locale: 'pt-BR', nome: 'Turista Feliz')

    visit '/perfil_de_pessoa/turista-feliz/roteiro_sugerido'

    expect(page).to have_content 'O ROTEIRO IDEAL PARA TURISTA FELIZ EM BONITO MS'

    expect(page).to have_field('start_date', with: Date.current.strftime('%d/%m/%Y'))
    expect(page).to have_field('end_date', with: (Date.current + 5.days).strftime('%d/%m/%Y'))
    expect(page).to have_field('adults', with: 2)

    within('#day_0') do
      expect(page).to have_content 'Dia 1 - ' + Date.current.strftime('%d/%m/%Y')
      expect(page).to have_content 'Você chega neste dia.'
      expect(page).to have_content 'Vamos deixar ele livre'
    end

    within('#day_5') do
      expect(page).to have_content 'Dia 6 - ' + (Date.current + 5.days).strftime('%d/%m/%Y')
      expect(page).to have_content 'Acabou...'
      expect(page).to have_content 'Neste dia você vai embora. :-('
      expect(page).to have_content 'Vamos deixar ele livre'
    end
  end
end
