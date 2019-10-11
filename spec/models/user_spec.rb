# frozen_string_literal: true

require 'rails_helper'

describe User do
  it 'returns converted carts belonging to user' do
    user_a = create(:user)
    user_b = create(:user)

    create_list(:cart, 3, user: user_a)
    create_list(:cart, 5, user: user_b)
    create_list(:cart, 3, :converted, user: user_a)
    create_list(:cart, 5, :converted, user: user_b)

    expect( Cart.count ).to eq 16
    expect( user_a.converted_carts.count ).to eq 3
    expect( user_b.converted_carts.count ).to eq 5
  end

  it 'returns cart that is still in process' do
    user_yes = create(:user)
    user_no = create(:user)

    create(:cart, user: user_yes, id: 1, data: '01/10/2010')
    create(:cart, user: user_yes, id: 2, data: '01/10/2020')
    create(:cart, user: user_yes, id: 3, data: '01/10/2015')
    create(:cart, :converted, user: user_yes, id: 4, data: '01/10/2020')
    create(:cart, :converted, user: user_yes, id: 5, data: '01/10/2015')
    create(:cart, user: user_no, id: 6)

    expect( Cart.count ).to eq 6
    expect( user_yes.cart_in_process.id ).to eq 2
  end
end
