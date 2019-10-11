# frozen_string_literal: true

require 'rails_helper'

describe CartConverter do
  it 'creates an itinerary based on a cart' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    cart = create(:cart, start_date: (Date.current + 2.days), end_date: (Date.current + 4.days))
    create(:cart_passenger, cart: cart)
    create(:cart_item, cart: cart, reserva: 'ABCXYZ', passeio_data: Date.current + 3.days)

    sale = create_sale

    expect do
      CartConverter.new.convert_to_itinerary(cart, sale)
    end
      .to change { Itinerary.count }.from(0).to(1)
      .and change { ItineraryTour.count }.from(0).to(1)
      .and change { Pax.count }.from(0).to(1)
      .and change { Payment.count }.from(0).to(1)
      .and change { ItineraryLog.count }.from(0).to(4)

    expect( Itinerary.first.inicio_da_viagem ).to eq Date.current + 2.days
    expect( Itinerary.first.fim_da_viagem ).to eq Date.current + 4.days
    expect( Itinerary.first.subtotal ).to eq cart.subtotal
    expect( Itinerary.first.desconto ).to eq cart.desconto
    expect( Itinerary.first.total ).to eq cart.total
    expect( Itinerary.first.total_lancamentos ).to eq sale.payment.amount/100.0
  end

  it 'emails itinerary to client and relevant people' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    cart = create(:cart, :with_pax_and_reserved_item)

    sale = create_sale
    CartConverter.new.convert_to_itinerary(cart, sale)

    from = ActionMailer::Base.deliveries.last.from
    to = ActionMailer::Base.deliveries.last.to
    bcc = ActionMailer::Base.deliveries.last.bcc

    expect(from).to include 'reservas@h2oecoturismo.com.br'

    expect(to).to include cart.user.email
    expect(to).to include 'adm@h2oecoturismo.com.br'
    expect(to).to include 'operacional@h2oecoturismo.com.br'
    expect(to).to include 'promocao@h2oecoturismo.com.br'
    expect(bcc).to include 'kassilene@h2oecoturismo.com.br'
  end

  it 'e-mails descriptive subject line and header' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    cart = create(:cart, :with_pax_and_reserved_item)

    sale = create_sale
    CartConverter.new.convert_to_itinerary(cart, sale)

    subject = ActionMailer::Base.deliveries.last.subject
    body = ActionMailer::Base.deliveries.last.body.raw_source

    expect(subject).to eq 'PD 1 - Reservas Confirmadas'

    expect(body).to include 'PD 1'
    expect(body).to include 'CA 1'
    expect(body).to include cart.user.nome
    expect(body).to include cart.user.email
    expect(body).to include 'COMPRA ONLINE - Reservas Confirmadas'
  end

  it 'includes tour and hotel information on e-mail' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    cart = create(:cart, :with_pax)

    tour = create(:tour)
    create(:tour_locale, :pt_br, tour: tour, nome: 'Blue Lagoon')
    cart_item = create(:cart_item, cart: cart, tour: tour, reserva: 'ABCXYZ', preco_total: 125000)

    hotel = create(:hotel)
    create(:hotel_locale, :pt_br, hotel: hotel, nome: 'The Love Shack')
    cart_hotel = create(:cart_hotel, cart: cart, hotel: hotel, adults: 2, children_ages: '', sale_price: 1.99)


    sale = create_sale
    CartConverter.new.convert_to_itinerary(cart, sale)

    body = ActionMailer::Base.deliveries.last.body.raw_source

    expect(body).to include (Date.current + 3.days).strftime('%d/%m/%Y')
    expect(body).to include '13:00'
    expect(body).to include 'Blue Lagoon'
    expect(body).to include 'R$ 125.000,00'

    expect(body).to include 'Entrada'
    expect(body).to include Date.current.strftime('%d/%m/%Y')
    expect(body).to include 'Saída'
    expect(body).to include (Date.current + 2.days).strftime('%d/%m/%Y')
    expect(body).to include 'The Love Shack'
    expect(body).to include '2 adulto(s)'
    expect(body).to include '2 diária(s) por'
    expect(body).to include 'R$ 1,99'
  end

  it 'uses a new itinerary for each new cart' do
    create(:institutional, :with_pt_br_locale, tag: 'email_compra_online_reservas_confirmadas')
    user = create(:user)
    create(:itinerary, user: user)
    cart = create(:cart, :with_pax_and_reserved_item, user: user)

    sale = create_sale

    expect do
      CartConverter.new.convert_to_itinerary(cart, sale)
    end
      .to change { Itinerary.count }.from(1).to(2)

    expect(Itinerary.first.usuario_id).to eq user.id
    expect(Itinerary.second.usuario_id).to eq user.id
  end

  it 'includes relevant information in itinerary creation log' do
    itinerary = create(:itinerary)

    CartConverter.new.send(:log_itinerary_creation, itinerary)

    expect(ItineraryLog.first.descricao).to include('<b>Cliente:</b>')
    expect(ItineraryLog.first.descricao).to include('<b>Localização:</b>')
    expect(ItineraryLog.first.descricao).to include('<b>Carrinho:</b>')
  end

  it 'updates itinerary pax with cart passengers' do
    itinerary = create(:itinerary)
    pax = create(:pax, itinerary: itinerary, nome: 'Milionário')

    cart = create(:cart)
    cart_passenger = create(:cart_passenger, cart: cart, nome: 'José Rico')

    expect do
      CartConverter.new.send(:update_itinerary_pax, itinerary, cart)
    end
      .to change { Pax.first.nome }.from('Milionário').to('José Rico')

    expect(ItineraryLog.first.descricao).to include '<b>Passageiro:</b> José Rico'
  end

  it 'updates itinerary tours with cart tours' do
    itinerary = create(:itinerary)
    itinerary_tour = create(:itinerary_tour, itinerary: itinerary, reserva: 'NOT ME')

    cart = create(:cart)
    tour = create(:tour, nome: 'Yes, I am the one!')
    cart_item = create(:cart_item, cart: cart, tour: tour, passeio_data: '19/03/2025',
                                                           passeio_hora: '09:00',
                                                           preco_total: 25,
                                                           qtde_adulto: 3,
                                                           qtde_crianca2: 1,
                                                           qtde_crianca: 2,
                                                           reserva: 'ABCXYZ')

    expect do
      CartConverter.new.send(:update_itinerary_tours, itinerary, cart)
    end
      .to change { ItineraryTour.first.reserva }.from('NOT ME').to('ABCXYZ')

    expect( ItineraryTour.first.passeio_data ).to eq Date.parse('19/03/2025')
    expect( ItineraryTour.first.passeio_hora.strftime('%H:%M') ).to eq '09:00'
    expect( ItineraryTour.first.passeio_hora.zone ).to eq 'UTC'
    expect( ItineraryTour.first.total ).to eq 25
    expect( ItineraryTour.first.qtde_adt ).to eq 3
    expect( ItineraryTour.first.qtde_chd ).to eq 1
    expect( ItineraryTour.first.qtde_free ).to eq 2
  end

  it 'logs itinerary tours info to itinerary logs' do
    itinerary = create(:itinerary)

    cart = create(:cart)
    tour = create(:tour, nome: 'Yes, I am the one!')
    cart_item = create(:cart_item, cart: cart, tour: tour, passeio_data: '19/03/2025',
                                                           passeio_hora: '09:00',
                                                           preco_total: 25,
                                                           qtde_adulto: 3,
                                                           qtde_crianca2: 1,
                                                           qtde_crianca: 2,
                                                           reserva: 'ABCXYZ')

    date_created_str = DateTime.current.strftime('%Y-%m-%d %H:%M')

    log_line_1 = '19/03/2025 - 09:00 - Yes, I am the one! - ABCXYZ - R$ 25,00'
    log_line_2 = 'Estoque:'

    CartConverter.new.send(:update_itinerary_tours, itinerary, cart)

    expect( ItineraryLog.first.created.strftime('%Y-%m-%d %H:%M') ).to eq date_created_str
    expect( ItineraryLog.first.created.zone ).to eq 'UTC'
    expect( ItineraryLog.first.adm_usuario_id ).to eq 133
    expect( ItineraryLog.first.loja_fisica_pedido_id ).to eq itinerary.id
    expect( ItineraryLog.first.acao ).to eq 'inseriu'

    expect( ItineraryLog.first.descricao ).to include log_line_1
    expect( ItineraryLog.first.descricao ).to include log_line_2
    expect( ItineraryLog.first.descricao ).to include '3 adulto(s)'
    expect( ItineraryLog.first.descricao ).to include '1 chd(s)'
    expect( ItineraryLog.first.descricao ).to include '2 free(s)'
  end

  it 'records stock information in itinerary logs' do
    itinerary = create(:itinerary)
    cart = create(:cart)
    create(:cart_item, cart: cart, tour_system: '234', reserva: 'ABCXYZ')

    CartConverter.new.send(:update_itinerary_tours, itinerary, cart)

    expect(ItineraryLog.first.descricao).to include 'Estoque: 234'
  end

  it 'considers lunch extra when creating itinerary tours' do
    itinerary = create(:itinerary, id: 5)

    cart = create(:cart)
    tour = create(:tour)
    tour_extra = create(:tour_extra, :pt_br_with_price, tour: tour, eh_almoco: true)

    create(:cart_item, cart: cart, tour: tour, reserva: 'ABCXYZ')
    create(:cart_tour_extra, cart: cart, tour_extra: tour_extra, adults_qty: 77,
                             children_qty: 33,
                             children2_qty: 55,
                             unit_qty: 0)

    CartConverter.new.send(:update_itinerary_tours, itinerary, cart)

    expect(ItineraryTour.first.qtde_adt_almoco).to eq 77
    expect(ItineraryTour.first.qtde_chd_almoco).to eq 33
    expect(ItineraryTour.first.qtde_free_almoco).to eq 55
    expect(ItineraryLog.first.descricao).to include '165 pessoa(s)'
  end

  it 'creates itinerary tour extras of the person type' do
    tour = create(:tour)
    tour_extra_price_type = create(:tour_extra_price_type, :person_pt_br)
    tour_extra = create(:tour_extra, :pt_br_with_price, tour: tour, tour_extra_price_type: tour_extra_price_type, nome: 'Algo Mais')

    itinerary = create(:itinerary)

    cart = create(:cart)
    cart_item = create(:cart_item, cart: cart, tour: tour, reserva: 'ABCXYZ')
    cart_tour_extra = create(:cart_tour_extra, cart: cart, tour_extra: tour_extra, unit_qty: 0)

    expect do
      CartConverter.new.send(:update_itinerary_tours, itinerary, cart)
    end
      .to change { ItineraryTourExtra.count }.from(0).to(1)

    expect(ItineraryLog.first.descricao).to include tour_extra.nome
    expect(ItineraryLog.first.descricao).to include ItineraryTourExtra.first.qtde_pessoa.to_s
    expect(ItineraryLog.first.descricao).not_to include 'unidade(s)'
  end

  it 'creates itinerary tour extras of the unit type' do
    tour = create(:tour)
    tour_extra_price_type = create(:tour_extra_price_type, :unit_pt_br)
    tour_extra = create(:tour_extra, :pt_br_with_price, tour: tour, tour_extra_price_type: tour_extra_price_type, nome: 'Algo Mais')

    itinerary = create(:itinerary)

    cart = create(:cart)
    cart_item = create(:cart_item, cart: cart, tour: tour, reserva: 'ABCXYZ')
    cart_tour_extra = create(:cart_tour_extra, cart: cart, tour_extra: tour_extra,
                                               adults_qty: 0, children_qty: 0, children2_qty: 0)

    expect do
      CartConverter.new.send(:update_itinerary_tours, itinerary, cart)
    end
      .to change { ItineraryTourExtra.count }.from(0).to(1)

    expect(ItineraryLog.first.descricao).to include tour_extra.nome
    expect(ItineraryLog.first.descricao).to include ItineraryTourExtra.first.qtde_unidade.to_s
    expect(ItineraryLog.first.descricao).not_to include 'pessoa(s)'
  end

  it 'creates payment record for itinerary' do
    itinerary = create(:itinerary)
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

    sale = CieloWrapper.run_payment(cart, params)

    expect do
      CartConverter.new.send(:create_payment, itinerary, sale)
    end
      .to change { Payment.count }.from(0).to(1)

    expect(Payment.first.valor).to eq 90
    expect(Payment.first.forma_de_pagamento).to eq 'Site H2O'
    expect(Payment.first.adm_usuario_id).to eq 133
    expect(Payment.first.loja_fisica_pedido_id).to eq itinerary.id
    expect(Payment.first.obs).to include 'Visa'
    expect(Payment.first.obs).to include 'Crédito'
    expect(Payment.first.obs).to include '3 parcela(s)'
  end

  it 'logs payment information in itinerary logs' do
    itinerary = create(:itinerary)
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

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect( ItineraryLog.first.descricao ).to include '<b>Pagamento: </b> Visa Crédito 3 parcela(s) '
    expect( ItineraryLog.first.descricao ).to include ' - R$ 90,00'
  end

  it 'handles cents correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 1.75)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect(Payment.first.valor).to eq 1.75
    expect(ItineraryLog.first.descricao).to include 'R$ 1,75'
  end

  it 'handles thousands correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 9000)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect(Payment.first.valor).to eq 9000
    expect(ItineraryLog.first.descricao).to include 'R$ 9.000,00'
  end

  it 'handles tens of thousands correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 90000)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect(Payment.first.valor).to eq 90000
    expect(ItineraryLog.first.descricao).to include 'R$ 90.000,00'
  end

  it 'handles hundreds of thousands correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 900000)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect(Payment.first.valor).to eq 900000
    expect(ItineraryLog.first.descricao).to include 'R$ 900.000,00'
  end

  it 'handles millions correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 9000000)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    expect(Payment.first.valor).to eq 9000000
    expect(ItineraryLog.first.descricao).to include 'R$ 9.000.000,00'
  end

  it 'handles tens of thousands and cents together correctly' do
    itinerary = create(:itinerary)
    cart = create(:cart, total: 90000.87)

    params = {
      card_number: '4111111111111111',
      brand: 'Visa',
      month: '11',
      year: '2055',
      cvv: '321',
      holder: 'Zé Rico',
      installments: 3
    }

    sale = CieloWrapper.run_payment(cart, params)

    CartConverter.new.send(:create_payment, itinerary, sale)

    payment = Payment.find_by_sql('SELECT id, ROUND(valor, 2) as valor FROM loja_fisica_pedido_lancamentos').first

    expect( payment.valor ).to eq 90000.87
    expect( ItineraryLog.first.descricao ).to include 'R$ 90.000,87'
  end

  it 'updates itinerary hotels with cart hotels' do
    itinerary = create(:itinerary)
    itinerary_hotel = create(:itinerary_hotel, itinerary: itinerary, reserva: 'NOT ME')

    cart = create(:cart)
    cart_hotel = create(:cart_hotel, cart: cart, start_date: '2500-05-14',
                                                 end_date: '2500-05-17',
                                                 adults: 2,
                                                 children_ages: '11',
                                                 number_of_nights: 3,
                                                 sale_price: 330,
                                                 room_type_name: 'Maravilhoso',
                                                 meal: 'Meia Pensão',
                                                 reservation_code: 'ABCXYZ')

    expect do
      CartConverter.new.send(:update_itinerary_hotels, itinerary, cart)
    end
      .to change { ItineraryHotel.first.reserva }.from('NOT ME').to('ABCXYZ')

    expect( ItineraryHotel.first.loja_fisica_pedido_id ).to eq itinerary.id
    expect( ItineraryHotel.first.produtos_hospedagem_fornecedore_id ).to eq cart_hotel.hotel.id
    expect( ItineraryHotel.first.quantidade ).to eq 1
    expect( ItineraryHotel.first.preco_unidade ).to eq 110
    expect( ItineraryHotel.first.total ).to eq 330
    expect( ItineraryHotel.first.produtos_hospedagem_configuracao_id ).to eq 9
    expect( ItineraryHotel.first.categoria ).to eq 'Maravilhoso'
    expect( ItineraryHotel.first.check_in ).to eq Date.parse('14/05/2500')
    expect( ItineraryHotel.first.check_out ).to eq Date.parse('17/05/2500')
    expect( ItineraryHotel.first.regime ).to eq 'Meia Pensão'
    expect( ItineraryHotel.first.check_in_hora.strftime('%H:%M') ).to eq '14:00'
    expect( ItineraryHotel.first.check_out_hora.strftime('%H:%M') ).to eq '11:00'
    expect( ItineraryHotel.first.pax_description ).to eq '2 adulto(s) + 1 criança 11 ano(s)'
  end

  it 'logs itinerary hotel info to itinerary logs' do
    itinerary = create(:itinerary)

    cart = create(:cart)
    hotel = create(:hotel, nome: 'Acolhedor')
    create(:cart_hotel, cart: cart, hotel: hotel, start_date: '2500-05-14',
                                                  end_date: '2500-05-17',
                                                  adults: 2,
                                                  children_ages: '11',
                                                  number_of_nights: 3,
                                                  sale_price: 330,
                                                  room_type_name: 'Maravilhoso',
                                                  meal: 'Meia Pensão',
                                                  reservation_code: 'ABCXYZ')

    date_created_str = DateTime.current.strftime('%Y-%m-%d %H:%M')

    log_line_1 = 'Acolhedor - 1 apto(s) - Outro (Maravilhoso) - Diária: R$ 110,00 - Total: R$ 330,00'
    log_line_2 = 'De 14/05/2500 às 14:00 até 17/05/2500 às 11:00 - Meia Pensão'
    log_line_3 = 'Hotels API: ABCXYZ'
    log_line_4 = '2 adulto(s) + 1 criança 11 ano(s)'

    CartConverter.new.send(:update_itinerary_hotels, itinerary, cart)

    expect( ItineraryLog.first.created.strftime('%Y-%m-%d %H:%M') ).to eq date_created_str
    expect( ItineraryLog.first.adm_usuario_id ).to eq 133
    expect( ItineraryLog.first.loja_fisica_pedido_id ).to eq itinerary.id
    expect( ItineraryLog.first.acao ).to eq 'inseriu'

    expect( ItineraryLog.first.descricao ).to include log_line_1
    expect( ItineraryLog.first.descricao ).to include log_line_2
    expect( ItineraryLog.first.descricao ).to include log_line_3
    expect( ItineraryLog.first.descricao ).to include log_line_4
  end
end
