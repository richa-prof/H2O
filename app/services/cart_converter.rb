class CartConverter
  def convert_to_itinerary(cart, sale)
    itinerary = Itinerary.where(usuario_id: cart.user.id, carrinho_id: cart.id).first_or_initialize
    itinerary.adm_usuario_id = 133
    itinerary.status = 'Pendente'
    itinerary.categoria = 'Site H2O'
    itinerary.hotel = cart.localizacao
    itinerary.inicio_da_viagem = cart.start_date
    itinerary.fim_da_viagem = cart.end_date
    itinerary.subtotal = cart.subtotal
    itinerary.desconto = cart.desconto
    itinerary.total = cart.total
    itinerary.total_lancamentos = sale.payment.amount/100.0
    itinerary.data = Time.now
    itinerary.canal_id = 4
    itinerary.indicador_id = 15
    itinerary.funil_venda_id = 8
    itinerary.status_kit_id = 1
    if itinerary.save
      log_itinerary_creation(itinerary)
      update_itinerary_pax(itinerary, cart)
      update_itinerary_tours(itinerary, cart)
      update_itinerary_hotels(itinerary, cart)
      create_payment(itinerary, sale)
      CartMailer.create_itinerary(itinerary).deliver
      return itinerary
    else
      return false
    end
  end

  private

  def log_itinerary_creation(itinerary)
    action = 'criou'
    statement = <<STATEMENT
<b>Cliente:</b> #{itinerary.user.nome}
<br/><b>Localização:</b> #{itinerary.hotel}
<br/><b>Carrinho:</b> #{itinerary.carrinho_id}
STATEMENT
    write_log(itinerary.id, action, statement)
  end

  def update_itinerary_pax(itinerary, cart)
    itinerary.paxs.destroy_all
    cart.cart_passengers.each do |p|
      itinerary.paxs.create(nome: p.nome, idade: p.idade, doc: p.doc)
      log_action = 'inseriu'
      log_statement = "<b>Passageiro:</b> #{p.nome} - #{p.idade} - #{p.doc}"
      write_log(itinerary.id, log_action, log_statement)
    end
  end

  def update_itinerary_tours(itinerary, cart)
    itinerary.itinerary_tours.destroy_all
    cart.cart_items.each do |ci|
      ci.reload
      it = itinerary.itinerary_tours.where(produto_id: ci.produto_id).first_or_initialize
      it.passeio_data = ci.passeio_data
      it.passeio_hora = ci.passeio_hora
      it.reserva = ci.reserva
      it.total = ci.preco_total
      it.qtde_adt = ci.qtde_adulto
      it.qtde_chd = ci.qtde_crianca2
      it.qtde_free = ci.qtde_crianca
      it.save

      if ci.tour_system == 'BTMS'
        stock_info = ''
      else
        stock_info = ci.tour_system
      end

      log_statement = <<STATEMENT
<b>#{it.passeio_data.strftime('%d/%m/%Y')} - #{it.passeio_hora.strftime('%H:%M')} - #{it.tour.nome} - #{it.reserva} - #{log_float_price(it.total)}<br/>Estoque: #{stock_info}</b>
<br/>#{it.qtde_adt} adulto(s)
 - #{it.qtde_chd} chd(s)
 - #{it.qtde_free} free(s)
STATEMENT
      ci.tour.tour_extras.where(id: cart.cart_tour_extras.pluck(:tour_extra_id)).each do |e|
        ite = it.itinerary_tour_extras.where(produtos_passeiosecundarios_id: e.id).first_or_initialize
        ite.tarifa_tipo_id = e.produtos_passeiosecundarios_tarifas_tipo_id
        cart_tour_extra = cart.cart_tour_extras.where(tour_extra_id: e.id).first
        ite.qtde_unidade = cart_tour_extra.unit_qty
        ite.qtde_pessoa = cart_tour_extra.adults_qty.to_i + cart_tour_extra.children_qty.to_i + cart_tour_extra.children2_qty.to_i
        ite.save
        if e.eh_almoco
          it.qtde_adt_almoco = cart_tour_extra.adults_qty
          it.qtde_chd_almoco = cart_tour_extra.children_qty
          it.qtde_free_almoco = cart_tour_extra.children2_qty
          it.save
        end
        log_statement << "<br/><b>#{e.nome}:</b> "
        log_statement << "#{ite.qtde_unidade} unidade(s)" if ite.qtde_unidade.present? && (ite.qtde_unidade > 0)
        log_statement << "#{ite.qtde_pessoa} pessoa(s)" if ite.qtde_pessoa.present? && (ite.qtde_pessoa > 0)
      end

      log_action = 'inseriu'
      write_log(itinerary.id, log_action, log_statement)
    end
  end

  def update_itinerary_hotels(itinerary, cart)
    itinerary.itinerary_hotels.destroy_all
    cart.cart_hotels.each do |ch|
      ch.reload

      pax_description = "#{ch.adults} adulto(s)"
      children_ages = ch.children_ages.split(' ').map{ |age| age.to_i }
      children_ages.each do |child_age|
        pax_description += " + 1 criança #{child_age} ano(s)"
      end

      ih = itinerary.itinerary_hotels.where(produtos_hospedagem_fornecedore_id: ch.hotel.id).first_or_initialize
      ih.quantidade = 1
      ih.preco_unidade = (ch.sale_price / ch.number_of_nights).round(2)
      ih.total = ch.sale_price
      ih.produtos_hospedagem_configuracao_id = 9
      ih.categoria = ch.room_type_name
      ih.check_in = ch.start_date
      ih.check_out = ch.end_date
      ih.reserva = ch.reservation_code
      ih.regime = ch.meal
      ih.check_in_hora = '14:00'
      ih.check_out_hora = '11:00'
      ih.pax_description = pax_description
      ih.save

      log_line_1 = "<b>#{ih.hotel.nome} - 1 apto(s) - Outro (#{ih.categoria}) - Diária: #{log_float_price(ih.preco_unidade)} - Total: #{log_float_price(ih.total)}</b>"
      log_line_2 = "De #{ih.check_in.strftime('%d/%m/%Y')} às 14:00 até #{ih.check_out.strftime('%d/%m/%Y')} às 11:00 - #{ih.regime}"
      log_line_3 = "Hotels API: #{ih.reserva}"

      log_action = 'inseriu'
      log_statement = log_line_1 + '<br/>' + log_line_2 + '<br/>' + log_line_3 + '<br/>' + ih.pax_description
      write_log(itinerary.id, log_action, log_statement)
    end
  end

  def create_payment(itinerary, sale)
    obs_string = sale.payment.credit_card.brand
    obs_string << ' Crédito ' if sale.payment.type == 'CreditCard'
    obs_string << sale.payment.installments.to_s + ' parcela(s) '
    obs_string << sale.payment.tid
    Payment.create(
      loja_fisica_pedido_id: itinerary.id,
      adm_usuario_id: 133,
      forma_de_pagamento: 'Site H2O',
      valor: sale.payment.amount/100.0,
      data: Date.current,
      obs: obs_string
    )
    log_action = 'inseriu'
    log_statement = "<b>Pagamento: </b> #{obs_string} - #{log_int_price(sale.payment.amount)}"
    write_log(itinerary.id, log_action, log_statement)
  end

  def write_log(itinerary_id, action, statement)
    ItineraryLog.create(
      adm_usuario_id: 133,
      loja_fisica_pedido_id: itinerary_id,
      descricao: statement,
      acao: action,
      created: DateTime.current.strftime('%Y-%m-%d %H:%M:%S')
    )
  end

  def log_float_price(float_price)
    "R$ #{format('%.2f', float_price).tr('.', ',').to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"
  end

  def log_int_price(int_price)
    "R$ #{int_price.to_s.insert(-3, ',').reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"
  end
end
