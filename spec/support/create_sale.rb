# frozen_string_literal: true

def create_sale
  cart = create(:cart, total: 90)

  params = {
    card_number: '4111111111111111',
    brand: 'Visa',
    month: '11',
    year: '2055',
    cvv: '321',
    holder: 'Zé Rico',
    installments: 3
  }

  CieloWrapper.run_payment cart, params
end
