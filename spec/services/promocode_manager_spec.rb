# frozen_string_literal: true

require 'rails_helper'

describe PromocodeManager do
  it 'makes sure promocode exists' do
    user = create(:user)

    cart = create(:cart)

    create(:cupon, chave: 'this-fun-cupon')

    expect(PromocodeManager.run_promocode('some-other-cupon', cart, user)).to eq(msg: 'invalid_promocode')
    expect(cart.desconto).to eq 0
  end

  it 'makes sure user is eligible' do
    user_yes = create(:user)
    user_no = create(:user)

    cart_1 = create(:cart, desconto: 0)
    cart_2 = create(:cart, desconto: 0)
    cart_3 = create(:cart, desconto: 0)
    cart_4 = create(:cart, desconto: 0)

    create(:cupon, chave: 'this-cupon-is-for-everyone', tipo: 'BRL', brl: 5)
    create(:cupon, chave: 'this-cupon-is-specific', tipo: 'BRL', brl: 5, usuario_id: user_yes.id)

    expect(PromocodeManager.run_promocode('this-cupon-is-for-everyone', cart_1, user_yes)).to eq(msg: 'applied_successfully')
    expect(cart_1.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-cupon-is-for-everyone', cart_2, user_no)).to eq(msg: 'applied_successfully')
    expect(cart_2.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-cupon-is-specific', cart_3, user_yes)).to eq(msg: 'applied_successfully')
    expect(cart_3.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-cupon-is-specific', cart_4, user_no)).to eq(msg: 'invalid_promocode')
    expect(cart_4.desconto).to eq 0
  end

  it 'makes sure cupon is not expired' do
    user = create(:user)

    cart_1 = create(:cart, desconto: 0)
    cart_2 = create(:cart, desconto: 0)

    create(:cupon, chave: 'this-one-is-valid', tipo: 'BRL', brl: 5, vencimento: Date.current + 5.days)
    create(:cupon, chave: 'this-one-has-expired', tipo: 'BRL', brl: 5, vencimento: Date.current - 5.days)

    expect(PromocodeManager.run_promocode('this-one-is-valid', cart_1, user)).to eq(msg: 'applied_successfully')
    expect(cart_1.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-one-has-expired', cart_2, user)).to eq(msg: 'promocode_expired')
    expect(cart_2.desconto).to eq 0
  end

  it 'makes sure cupon has not reached limit' do
    user = create(:user)

    cart_1 = create(:cart, desconto: 0)
    cart_2 = create(:cart, desconto: 0)
    cart_3 = create(:cart, desconto: 0)

    create(:cupon, chave: 'this-is-unlimited', tipo: 'BRL', brl: 5, limite: nil)
    create(:cupon, chave: 'this-is-within-limit', tipo: 'BRL', brl: 5, limite: 1, vezes_usado: 0)
    create(:cupon, chave: 'this-is-finished', tipo: 'BRL', brl: 5, limite: 1, vezes_usado: 1)

    expect(PromocodeManager.run_promocode('this-is-unlimited', cart_1, user)).to eq(msg: 'applied_successfully')
    expect(cart_1.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-is-within-limit', cart_2, user)).to eq(msg: 'applied_successfully')
    expect(cart_2.desconto).to eq 5

    expect(PromocodeManager.run_promocode('this-is-finished', cart_3, user)).to eq(msg: 'reached_limit')
    expect(cart_3.desconto).to eq 0
  end

  it 'applies percentage discount' do
    user = create(:user)

    cart = create(:cart, subtotal: 10)

    cupon = create(:cupon, chave: 'percentage-discount', tipo: 'Porcentagem', porcentagem: 25)

    expect(PromocodeManager.run_promocode('percentage-discount', cart, user)).to eq(msg: 'applied_successfully')
    expect(cart.desconto).to eq 2.5
    expect(cart.total).to eq 7.5
    expect(cart.cupom_id).to eq cupon.id
  end

  it 'applies BRL discount' do
    user = create(:user)

    cart = create(:cart, subtotal: 30)

    cupon = create(:cupon, chave: 'brl-discount', tipo: 'BRL', brl: 25)

    expect(PromocodeManager.run_promocode('brl-discount', cart, user)).to eq(msg: 'applied_successfully')
    expect(cart.desconto).to eq 25
    expect(cart.total).to eq 5
    expect(cart.cupom_id).to eq cupon.id
  end

  it 'applies other type' do
    user = create(:user)

    cart = create(:cart)

    cupon = create(:cupon, chave: 'fun-prize', tipo: 'Fun Prize')

    expect(PromocodeManager.run_promocode('fun-prize', cart, user)).to eq(msg: 'congratulations_prize', extra: 'Fun Prize')
    expect(cart.desconto).to eq nil
    expect(cart.total).to eq cart.subtotal
    expect(cart.cupom_id).to eq cupon.id
  end
end
