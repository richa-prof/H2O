# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!, except: %i[add_to_cart remove_from_cart]
  before_action :set_cart_in_process, except: [:confirmation]
  before_action :escape_if_cart_is_empty, except: %i[add_to_cart remove_from_cart confirmation]

  def add_to_cart
    count_this_session_cart if session[:cart].nil?
    session[:cart] = nil if session[:cart]&.keys != ['tours', 'hotels']
    session[:cart] = session[:cart] || clean_session_cart

    if params[:tour_id].present?
      session[:cart]['tours'].deep_merge!(
        {
          params[:tour_id] => {
            'tour_selected_date' => params[:tour_selected_date],
            'tour_selected_time' => params[:tour_selected_time],
            'tour_system' => params[:tour_system],
            'tour_adults' => params[:tour_adults],
            'tour_children' => params[:tour_children],
            'tour_children2' => params[:tour_children2],
            'tour_final_price' => params[:tour_final_price],
            'tour_extra' => params[:tour_extra],
            'tour_extra_persons' => tour_extra_persons
          }
        }
      )
    end

    if params[:hotel_id].present?
      session[:cart]['hotels'].deep_merge!(
        {
          params[:hotel_id] => {
            'request_echo_token' => params[:request_echo_token],
            'start_date' => params[:start_date],
            'end_date' => params[:end_date],
            'adults' => params[:adults],
            'children_ages' => params[:children_ages],
            'number_of_nights' => params[:number_of_nights],
            'room_type_name' => params[:room_type_name],
            'room_selected' => params[:room_selected],
            'sale_price' => params[:sale_price]
          }
        }
      )
    end

    check_cart_items

    @tours = session[:cart]['tours'].count > 0 ? Tour.display_on_webiste.includes(:tour_locales, :tour_prices, tour_facilities: [:facility]).where(id: session[:cart]['tours'].keys).where('produtos_locales.locale = ?', params[:locale]).references(:tour_locales) : []

    @hotels = session[:cart]['hotels'].count > 0 ? Hotel.display_on_webiste.includes(:hotel_locales, :facilities).where(id: session[:cart]['hotels'].keys).where('produtos_hospedagem_fornecedores_locales.locale = ?', params[:locale]).references(:hotel_locales) : []
  end

  def remove_from_cart
    if params[:id].blank? || params[:item_class].blank?
      redirect_to add_to_cart_carts_path, alert: (t 'remove_from_cart_unsuccessful')
    else
      if params[:item_class] == 'Tour'
        session[:cart]['tours'].delete(params[:id])
        @cart.cart_items.where(produto_id: params[:id]).destroy_all if @cart.present?
      end

      if params[:item_class] == 'Hotel'
        session[:cart]['hotels'].delete(params[:id])
        @cart.cart_hotels.where(hotel_id: params[:id]).destroy_all if @cart.present?
      end

      redirect_to add_to_cart_carts_path, notice: (t 'removed_from_cart_successfully')
    end
  end

  def additional_information
    if session[:cart].present? && (session[:cart]['tours'].count + session[:cart]['hotels'].count) > 0
      @cart = CartBuilder.new.build_this session[:cart], @cart
    end
    session[:cart] = clean_session_cart
  end

  def update
    if @cart.update(cart_params)
      current_user.update(telefone: params[:telefone]) if params[:telefone].present?
      redirect_to payment_carts_path(id: @cart.id), notice: (t 'successfully_updated_info')
    else
      redirect_to additional_information_carts_path, notice: @cart.errors.full_messages.join(', ')
    end
  end

  def payment
    redirect_to additional_information_carts_path, notice: (t 'add_people') if @cart.cart_passengers.count == 0

    @cart.refresh_totals
    CartMailer.reservations_requested(@cart).deliver
  end

  def check_promocode
    if params[:cupom_id].present?
      promocode_notice = PromocodeManager.run_promocode(params[:cupom_id], @cart, current_user)
      flash[:notice] = t promocode_notice[:msg]
      flash[:notice] += ' ' + promocode_notice[:extra] if promocode_notice[:extra].present?
    else
      @cart.update(cupom_id: 0, desconto: 0.0, total: @cart.subtotal)
    end
    redirect_to payment_carts_path(id: @cart.id)
  end

  def charge
    confirmation_params = CartCharger.new.charge @cart, payment_params
    clean_session_cart

    redirect_to confirmation_carts_path(confirmation_params)
  end

  def confirmation
    @parameters = confirmation_params
    @cart = Cart.find(@parameters[:id])

    unless @parameters[:problem_item_id].blank?
      if @parameters[:problem_item_class] == 'Tour'
        @problem_tour = Tour.includes(:tour_locales).find(@parameters[:problem_item_id])
      end

      if @parameters[:problem_item_class] == 'Hotel'
        @problem_hotel = Hotel.includes(:hotel_locales).find(@parameters[:problem_item_id])
      end
    end

    redirect_to add_to_cart_carts_path if @cart.user != current_user
  end

  private

  def cart_params
    params.require(:cart).permit(:localizacao, :telefone, cart_passengers_attributes: %i[id nome idade doc _destroy])
  end

  def payment_params
    params.permit(:card_number, :brand, :month, :year, :cvv, :holder, :installments)
  end

  def confirmation_params
    params.permit(:id, :img, :itinerary_id, :sale_status, :sale_return_code, :sale_return_message, :sale_return_description, :sale_client_action, :temp_reservations_status, :problem_item_class, :problem_item_id)
  end

  def set_cart_in_process
    if current_user.present?
      @cart = current_user.cart_in_process
      if @cart.present?
        @cart.refresh_tour_prices
      else
        @cart = Cart.new(usuario_id: current_user.id, data: DateTime.current)
        @cart.save
      end
    end
  end

  def check_cart_items
    unless @cart.blank?
      @this_cart_has_items = true if @cart.cart_items.any? || @cart.cart_hotels.any?
    end

    if session[:cart].respond_to?(:dig)
      unless session[:cart].dig('tours').blank?
        session[:cart]['tours'].delete_if {|k,info| ensure_valid_date(info['tour_selected_date']) < Date.current}
        @this_cart_has_items = true if session[:cart]['tours'].count > 0
      end

      unless session[:cart].dig('hotels').blank?
        session[:cart]['hotels'].delete_if {|k,info| ensure_valid_date(info['start_date']) < Date.current}
        @this_cart_has_items = true if session[:cart]['hotels'].count > 0
      end
    end
  end

  def escape_if_cart_is_empty
    check_cart_items
    redirect_to add_to_cart_carts_path, notice: (t 'empty_cart') unless @this_cart_has_items
  end

  def tour_extra_persons
    tour_extra_persons = {}
    if params[:tour_extra].present?
      params[:tour_extra].each do |te|
        tour_extra = TourExtra.find_by(id: te)
        if tour_extra.produtos_passeiosecundarios_tarifas_tipo_id == 1
          tour_extra_persons.merge!(te => { 'adults' => params['tour_extra_adults_' + te].to_i,
                                            'children' => params['tour_extra_children_' + te].to_i,
                                            'children2' => params['tour_extra_children2_' + te].to_i })
        else
          tour_extra_persons.merge!(te => { 'unit' => params['tour_extra_unit_' + te].to_i })
        end
      end
    end
    tour_extra_persons
  end

  def count_this_session_cart
    session_cart_count_today = SessionCartCount.where(date_recorded: Date.current).first_or_create
    session_cart_count_today.update(date_count: session_cart_count_today.date_count.to_i + 1)
  end

  def clean_session_cart
    { 'tours' => {}, 'hotels' => {} }
  end

  def ensure_valid_date date_being_checked
    some_old_valid_date = Date.current - 50.years
    return some_old_valid_date if date_being_checked.blank?

    begin
       Date.parse(date_being_checked)
    rescue ArgumentError
       some_old_valid_date
    end
  end
end
