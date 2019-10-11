# frozen_string_literal: true

class TourReservationsManager
  def initialize(cart)
    @cart = cart
    @btms = BTMSWrapper.new

    @temp_reservations = {}
    @temp_reservations[:status_btms] = false
    @temp_reservations[:status_stock] = false
    @temp_reservations[:status] = false
    @temp_reservations[:problem_tour_id] = ''

    @confirm_reservations_status = false
  end

  def make_temp_reservations
    @temp_reservations[:status_btms] = true

    if @cart.has_stock_items?
      handle_stock
    else
      @temp_reservations[:status_stock] = true
    end

    @temp_reservations[:status] = @temp_reservations[:status_btms] && @temp_reservations[:status_stock]
    @temp_reservations
  end

  def handle_stock
    @cart.cart_items.each do |ci|
      if ci.tour_system != 'BTMS' && ci.tour_system != '' && ci.tour_system != nil
        stock_to_use = TourStockDate.find(ci.tour_system)
        slots_to_take = ci.qtde_adulto.to_i + ci.qtde_crianca.to_i + ci.qtde_crianca2.to_i

        if stock_to_use.present? && slots_to_take <= stock_to_use.estoque
          stock_to_use.update(estoque: stock_to_use.estoque - slots_to_take)
          ci.update(reserva: stock_to_use.numero_de_reserva)
          @temp_reservations[:status_stock] = true
        else
          @temp_reservations[:problem_tour_id] = ci.produto_id
        end
      end
    end
  end

  def confirm_reservations
    @confirm_reservations_status = true
  end

  def cancel_reservations
    if @cart.has_stock_items?
      return_stock_slots
    end
  end

  def return_stock_slots
    @cart.cart_items.each do |ci|
      if ci.tour_system != 'BTMS' && ci.tour_system != '' && ci.tour_system != nil
        stock_to_use = TourStockDate.find(ci.tour_system)
        slots_to_return = ci.qtde_adulto + ci.qtde_crianca + ci.qtde_crianca2

        if stock_to_use.present?
          stock_to_use.update(estoque: stock_to_use.estoque + slots_to_return)
          ci.update(reserva: '(estoque devolvido)')
        end
      end
    end
  end
end
