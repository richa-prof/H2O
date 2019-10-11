# frozen_string_literal: true

require 'rails_helper'

describe CieloWrapper do
  it 'returns confirmed payment info from Cielo' do
    cart = create(:cart)

    params = {}
    params[:card_number] = '4111111111111111'
    params[:brand] = 'Visa'
    params[:month] = '11'
    params[:year] = '2055'
    params[:cvv] = '321'
    params[:holder] = 'Zé Rico'
    params[:installments] = 1

    sale = CieloWrapper.run_payment(cart, params)
    payment_info = sale.payment

    expect( payment_info.status ).to eq 2
    expect( payment_info.return_code ).to eq '6'
    expect( payment_info.return_message ).to eq 'Operation Successful'
  end

  it 'returns declined payment info from Cielo' do
    cart = create(:cart)

    params = {}
    params[:card_number] = '5555555555555552'
    params[:brand] = 'Master'
    params[:month] = '11'
    params[:year] = '2055'
    params[:cvv] = '321'
    params[:holder] = 'Zé Rico'
    params[:installments] = 1

    sale = CieloWrapper.run_payment(cart, params)
    payment_info = sale.payment

    expect( payment_info.status ).to eq 3
    expect( payment_info.return_code ).to eq '05'
    expect( payment_info.return_message ).to eq 'Not Authorized'
  end

  it 'logs declined payment info from Cielo' do
    cart = create(:cart)

    params = {}
    params[:card_number] = '5555555555555552'
    params[:brand] = 'Master'
    params[:month] = '11'
    params[:year] = '2055'
    params[:cvv] = '321'
    params[:holder] = 'Zé Rico'
    params[:installments] = 1

    sale = CieloWrapper.run_payment(cart, params)

    expect( MyVeryOwnLog.first.authoring_class ).to eq 'CieloWrapper'
    expect( MyVeryOwnLog.first.authoring_method ).to eq 'run_payment'
    expect( MyVeryOwnLog.first.authoring_user_email ).to eq cart.user.email
    expect( MyVeryOwnLog.first.info ).to include '[declined] CA 1'
    expect( MyVeryOwnLog.first.info ).to include 'Cartão: Master 555555******5552 - Portador: Zé Rico'
    expect( MyVeryOwnLog.first.info ).to include 'Status: 3 - Return: 05 - Not Authorized'
  end

  it 'logs erros in Cielo communication' do
    cart = create(:cart)

    params = {}
    params[:card_number] = '5555555555555552'
    params[:brand] = 'Master'
    params[:month] = '11'
    params[:year] = '2055'
    params[:cvv] = '321'
    params[:holder] = 'Zé Rico'
    params[:installments] = nil

    CieloWrapper.run_payment(cart, params)

    expect( MyVeryOwnLog.first.authoring_class ).to eq 'CieloWrapper'
    expect( MyVeryOwnLog.first.authoring_method ).to eq 'run_payment'
    expect( MyVeryOwnLog.first.authoring_user_email ).to eq cart.user.email
    expect( MyVeryOwnLog.first.info ).to include '[rescue] CA 1 => Error [123]'
    expect( MyVeryOwnLog.first.info ).to include 'Installments must be greater or equal to one'
  end
end
