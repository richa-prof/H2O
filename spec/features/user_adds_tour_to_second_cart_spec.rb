# frozen_string_literal: true

require 'rails_helper'

feature 'user adds tour to second cart' do
  scenario 'sucessfully' do
    user = create(:user)
    cart = create(:cart, :converted, user: user)

    tour_price_type = create(:tour_price_type)

    first_tour = create(:tour)
    create(:tour_locale, :pt_br, tour: first_tour, nome: 'This One First')
    create(:tour_price, tour_price_type: tour_price_type, tour: first_tour)
    create(:cart_item, cart: cart, tour: first_tour)

    second_tour = create(:tour, link: 'this-is-second')
    create(:tour_locale, :pt_br, tour: second_tour, nome: 'This Is Second')
    create(:tour_price, tour_price_type: tour_price_type, tour: second_tour)

    login_as user

    visit '/passeios/this-is-second'

    find('a.tour_time').click

    find('button[data-field="adults"][data-type="plus"]').click

    find('a#add_to_trip_btn').click

    expect(page).not_to have_content 'THIS ONE FIRST'
    expect(page).to have_content 'THIS IS SECOND'
  end
end
