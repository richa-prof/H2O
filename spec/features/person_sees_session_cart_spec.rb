# frozen_string_literal: true

require 'rails_helper'

feature 'person sees session cart' do
  scenario 'successfully pt-BR' do
    tour = create(:tour, :with_pt_br_locale)
    create(:tour_price, tour: tour, fim: '14/05/2075')
    session_cart = {
      'tours' => {
        tour.id.to_s => {
          'tour_selected_date' => '14/05/2055',
          'tour_selected_time' => '05:04',
          'tour_system' => 'BTMS',
          'tour_adults' => '5',
          'tour_children' => '3',
          'tour_children2' => '1',
          'tour_final_price' => '1000.98',
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {}
    }

    inject_session cart: session_cart

    visit '/carrinho/add_to_cart'

    expect(page).to have_content tour.tour_locales.where(locale: 'pt-BR').first.nome.upcase
    expect(page).to have_content '14/05/2055'
    expect(page).to have_content '05:04'
    expect(page).to have_content 'R$ 1.000,98'
  end

  scenario 'successfully en-US' do
    tour = create(:tour, :with_locale)
    create(:tour_price, tour: tour, fim: '14/05/2075')
    session_cart = {
      'tours' => {
        tour.id.to_s => {
          'tour_selected_date' => '14/05/2055',
          'tour_selected_time' => '05:04',
          'tour_system' => 'BTMS',
          'tour_adults' => '5',
          'tour_children' => '3',
          'tour_children2' => '1',
          'tour_final_price' => '1000.98',
          'tour_extra' => nil,
          'tour_extra_persons' => {}
        }
      },
      'hotels' => {}
    }
    
    inject_session cart: session_cart

    visit '/en/cart/add_to_cart'

    expect(page).to have_content tour.tour_locales.where('locale = ?', 'en-US').first.nome.upcase
    expect(page).to have_content '14 May 2055'
    expect(page).to have_content '05:04'
    expect(page).to have_content '1,000.98 BRL'
  end
end
