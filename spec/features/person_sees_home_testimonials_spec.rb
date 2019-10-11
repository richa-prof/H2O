# frozen_string_literal: true

require 'rails_helper'

feature 'person sees home testimonials' do
  scenario 'sucessfully' do
    create(:testimonial, nome: 'João Pé de Feijão',
                         cidade: 'João Pessoa',
                         texto: 'Very cool place and staff! ' + Faker::Lorem.paragraph_by_chars(250, false),
                         created: '14/05/2018')

    visit root_path

    within 'section.testimonials-bg' do
      expect(page).to have_css 'h1', text: 'Depoimentos'
      expect(page).to have_css 'h2', text: 'João Pé de Feijão'
      expect(page).to have_css 'h3', text: 'João Pessoa'
      expect(page).to have_content 'Very cool place and staff!'
      expect(page).to have_css 'h4', text: '14/05/2018'
    end
  end

  scenario 'sucessfully' do
    create(:testimonial, nome: 'João Pé de Feijão',
                         cidade: 'João Pessoa',
                         texto: 'Very cool place and staff! ' + Faker::Lorem.paragraph_by_chars(250, false),
                         created: '14/05/2018')

    visit '/en'

    within 'section.testimonials-bg' do
      expect(page).to have_css 'h1', text: 'Testimonials'
      expect(page).to have_css 'h2', text: 'João Pé de Feijão'
      expect(page).to have_css 'h3', text: 'João Pessoa'
      expect(page).to have_content 'Very cool place and staff!'
      expect(page).to have_css 'h4', text: '14 May 2018'
    end
  end
end
