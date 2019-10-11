class CartBuilder
  def build_this session_cart, object_cart
    @cart = object_cart
    @session_cart = session_cart

    build_tours
    build_hotels

    if @cart.cart_hotels.size > 0
      start_date = @cart.cart_hotels.pluck(:start_date).min
      end_date = @cart.cart_hotels.pluck(:end_date).max
    else
      start_date = @cart.cart_items.pluck(:passeio_data).min
      end_date = @cart.cart_items.pluck(:passeio_data).max
    end

    @cart.update(start_date: start_date, end_date: end_date)
    @cart.refresh_totals
  end

  private

  def build_tours
    @session_cart['tours'].each do |t|
      cart_item = @cart.cart_items.where(produto_id: t[0].to_i).first_or_initialize
      cart_item.produto_variacao_id = 1
      cart_item.produto_subvariacao_id = 1
      cart_item.preco_unitario = 1
      cart_item.qtde = t[1]['tour_adults'].to_i + t[1]['tour_children'].to_i + t[1]['tour_children2'].to_i
      cart_item.passeio_data = t[1]['tour_selected_date']
      cart_item.passeio_hora = t[1]['tour_selected_time']
      cart_item.tour_system = t[1]['tour_system']
      cart_item.qtde_adulto = t[1]['tour_adults']
      cart_item.qtde_crianca = t[1]['tour_children']
      cart_item.qtde_crianca2 = t[1]['tour_children2']
      cart_item.preco_total = t[1]['tour_final_price']
      cart_item.save
      next if t[1]['tour_extra'].blank?

      t[1]['tour_extra'].each do |e|
        total_quantity = t[1]['tour_extra_persons'][e]['unit'].to_i + t[1]['tour_extra_persons'][e]['adults'].to_i + t[1]['tour_extra_persons'][e]['children'].to_i + t[1]['tour_extra_persons'][e]['children2'].to_i

        next unless total_quantity > 0

        tour_extra = @cart.cart_tour_extras.where(tour_extra_id: e.to_i).first_or_initialize
        tour_extra.unit_qty = t[1]['tour_extra_persons'][e]['unit']
        tour_extra.adults_qty = t[1]['tour_extra_persons'][e]['adults']
        tour_extra.children_qty = t[1]['tour_extra_persons'][e]['children']
        tour_extra.children2_qty = t[1]['tour_extra_persons'][e]['children2']
        tour_extra.save
      end
    end
  end

  def build_hotels
    @session_cart['hotels'].each do |h|
      cart_hotel = @cart.cart_hotels.where(hotel_id: h[0].to_i).first_or_initialize
      cart_hotel.request_echo_token = h[1]['request_echo_token']
      cart_hotel.start_date = h[1]['start_date']
      cart_hotel.end_date = h[1]['end_date']
      cart_hotel.adults = h[1]['adults']
      cart_hotel.children_ages = h[1]['children_ages']
      cart_hotel.number_of_nights = h[1]['number_of_nights']
      cart_hotel.room_type_name = h[1]['room_type_name']
      cart_hotel.room_selected = h[1]['room_selected']
      cart_hotel.sale_price = h[1]['sale_price']
      cart_hotel.save
    end
  end
end
