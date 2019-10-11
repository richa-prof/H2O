# frozen_string_literal: true

class CieloWrapper
  def self.run_payment(cart, params)
    require 'cielo/api30'

    payment_amount_in_cents = (cart.total.round(2) * 100).to_i

    cielo_sale = Cielo::API30::Sale.new(cart.id)
    cielo_sale.customer = Cielo::API30::Customer.new(cart.user.nome)
    cielo_sale.payment = Cielo::API30::Payment.new(payment_amount_in_cents)
    cielo_sale.payment.type = Cielo::API30::Payment::PAYMENTTYPE_CREDITCARD
    cielo_sale.payment.installments = params[:installments]
    cielo_sale.payment.soft_descriptor = 'dev test'
    cielo_sale.payment.capture = true
    cielo_sale.payment.credit_card = Cielo::API30::CreditCard.new(security_code: params[:cvv])
    cielo_sale.payment.credit_card.card_number = params[:card_number]
    cielo_sale.payment.credit_card.brand = params[:brand]
    cielo_sale.payment.credit_card.expiration_date = params[:month] + '/' + params[:year]
    cielo_sale.payment.credit_card.holder = params[:holder]

    cielo_environment = Cielo::API30::Environment.sandbox
    cielo_merchant = Cielo::API30.merchant('ee588bf4-0297-453a-8560-b777838e075f', 'JEZQVIEXZPEXSKYTDYQUEZGBQTVFSAGUNNEHHNCV')

    cielo_api = Cielo::API30.client(cielo_merchant, cielo_environment)

    this_sale = cielo_api.create_sale(cielo_sale)
    this_payment = this_sale.payment

    if this_payment.present? && this_payment.status != 2
      MyVeryOwnLog.create(authoring_class: 'CieloWrapper',
                          authoring_method: 'run_payment',
                          authoring_user_email: cart.user.email,
                          info: "[declined] CA #{cart.id} => Cartão: #{this_payment.credit_card&.brand} #{this_payment.credit_card&.card_number} - Portador: #{this_payment.credit_card&.holder} - Status: #{this_payment.status} - Return: #{this_payment.return_code} - #{this_payment.return_message}")
      MyVeryOwnLog.create(authoring_class: 'CieloWrapper',
                          authoring_method: 'run_payment',
                          authoring_user_email: cart.user.email,
                          info: "[declined] CA #{cart.id} => Return Info Message: #{this_payment.return_info&.message}")
      MyVeryOwnLog.create(authoring_class: 'CieloWrapper',
                          authoring_method: 'run_payment',
                          authoring_user_email: cart.user.email,
                          info: "[declined] CA #{cart.id} => Return Info Description: #{this_payment.return_info&.description}")
      MyVeryOwnLog.create(authoring_class: 'CieloWrapper',
                          authoring_method: 'run_payment',
                          authoring_user_email: cart.user.email,
                          info: "[declined] CA #{cart.id} => Return Info Action: #{this_payment.return_info&.action}")
    end

    this_sale
  rescue Exception => e
    MyVeryOwnLog.create(authoring_class: 'CieloWrapper',
                        authoring_method: 'run_payment',
                        authoring_user_email: cart.user.email,
                        info: "[rescue] CA #{cart.id.to_s} => #{e.to_s}")
    false
  end
end
