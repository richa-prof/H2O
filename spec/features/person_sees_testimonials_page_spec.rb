# frozen_string_literal: true

require 'rails_helper'

feature 'person sees testimonials page' do
  scenario 'sucessfully' do
    institutional = create(:institutional, tag: 'depoimentos')
    create(:institutional_locale, institutional: institutional, titulo_menu: 'Testimonials',
                                  titulo: 'Testimonials from H2O Clients')
    create(:testimonial, institutional: institutional, nome: 'Lewis Litt',
                         email: 'my-email@domain.com',
                         texto: 'Everything was great!',
                         cidade: 'Stars Hollow')

    visit '/en/institutional/depoimentos'

    expect(page).to have_content 'Testimonials from H2O Clients'
    expect(page).to have_content 'Everything was great!'
    expect(page).to have_content 'Stars Hollow'
    expect(page).not_to have_content 'my-email@domain.com'
  end
end
