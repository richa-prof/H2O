# frozen_string_literal: true

class CartCharger
  def charge cart, payment_params
    @cart = cart
    @payment_params = payment_params
    @tour_reservations_manager = TourReservationsManager.new @cart
    @hotel_reservations_manager = HotelReservationsManager.new @cart
    initialize_confirmation_params

    process_payment_and_reservations if make_temp_reservations

    @confirmation_params
  end

  private

  def initialize_confirmation_params
    @confirmation_params = {}
    @confirmation_params[:id] = @cart.id
    @confirmation_params[:img] = 'cancel.png'
  end

  def make_temp_reservations
    tour_temp_reservations = @tour_reservations_manager.make_temp_reservations

    unless tour_temp_reservations[:status]
      @confirmation_params[:temp_reservations_status] = 'false'
      if Tour.exists? id: tour_temp_reservations[:problem_tour_id]
        @confirmation_params[:problem_item_class] = 'Tour'
        @confirmation_params[:problem_item_id] = tour_temp_reservations[:problem_tour_id]
      end
      return false
    end

    hotel_availability = @hotel_reservations_manager.check_availability

    unless hotel_availability[:status]
      @confirmation_params[:temp_reservations_status] = 'false'
      if Hotel.exists? id: hotel_availability[:problem_hotel_id]
        @confirmation_params[:problem_item_class] = 'Hotel'
        @confirmation_params[:problem_item_id] = hotel_availability[:problem_hotel_id]
      end
      return false
    end

    true
  end

  def process_payment_and_reservations
    @sale = CieloWrapper.run_payment @cart, @payment_params

    unless @sale&.payment&.blank?
      if @sale.payment.status.to_s == '2'
        confirm_and_convert
      else
        cancel_and_let_go
      end

      @confirmation_params[:sale_status] = @sale.payment.status.to_s
      @confirmation_params[:sale_return_code] = @sale.payment.return_code
      @confirmation_params[:sale_return_message] = @sale.payment.return_message
      @confirmation_params[:sale_return_description] = @sale.payment.return_info.description
      @confirmation_params[:sale_client_action] = @sale.payment.return_info.action
    end
  end

  def confirm_and_convert
    tour_confirmations = @tour_reservations_manager.confirm_reservations
    hotel_reservations = true

    if tour_confirmations && hotel_reservations
      itinerary = CartConverter.new.convert_to_itinerary @cart, @sale

      if itinerary
        @confirmation_params[:img] = 'success.png'
        @confirmation_params[:itinerary_id] = itinerary.id
      end
    end
  end

  def cancel_and_let_go
    @tour_reservations_manager.cancel_reservations
  end
end
