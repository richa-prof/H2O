# frozen_string_literal: true

require 'rails_helper'

feature 'person sees tour times' do
  scenario 'sucessfully' do
    tour = create(:tour, :with_pt_br_locale, link: 'este-passeio')

    visit '/passeios/este-passeio'

    within 'ul.time' do
      expect(page).to have_content '11:00'

      expect(page).not_to have_content '07:00'
    end
  end
end
