# frozen_string_literal: true

class HotelsController < ApplicationController
  def index
    initiate_hotels
    filter_hotels
    @hotels = @hotels.paginate(page: params[:page], per_page: 12)
  end

  def show
    @hotel = Hotel.find_for_show params[:locale], params[:id]

    if @hotel.is_a? Hotel
      @start_date = Date.current
      @end_date = Date.current + 3.days

      @adults = 2
      @children = 0
    else
      redirect_to search_path(search_box: params[:id]), status: :not_found
    end
  end

  def availability
    if request.format == :js
      @hotel = Hotel.friendly.find(params[:id])

      @start_date = ensure_date_is_valid params[:start_date]
      @end_date = ensure_date_is_valid params[:end_date]

      @adults = params[:adults].to_i
      @children = params[:children].to_i
      @children_ages = params[:children_ages].split(',').map{ |age| age.to_i }

      guest_count = [{
        total: @adults + @children,
        adults: @adults,
        children: @children,
        children_ages: @children_ages
      }]

      availability_request_info = {
        guest_count: guest_count,
        hotel_id: @hotel.hotels_api_code,
        start_date: @start_date.strftime('%Y-%m-%d'),
        end_date: @end_date.strftime('%Y-%m-%d')
      }

      @availability = HotelsAPIWrapper.new.availability availability_request_info, params[:locale]

      @number_of_nights = (@end_date - @start_date).to_i

      expires_in 30.minutes, public: true, must_revalidate: true if Rails.env.production?
    else
      render body: nil, status: 415
    end
  end

  private

  def ensure_date_is_valid submitted_date
    return Date.current if submitted_date.blank?

    begin
       Date.parse(submitted_date)
    rescue ArgumentError
       Date.current
    end
  end

  def initiate_hotels
    @meals = Meal.display.includes(:meal_locales).where('regimes_locales.locale = ?', params[:locale]).references(:meal_locales)
    @facilities = Facility.display.joins(:hotel_facilities).uniq

    @hotels = Hotel.display_on_webiste_with_locale(params[:locale]).includes(hotel_facilities: [:facility])
    @hotels = @hotels.where('produtos_hospedagem_fornecedores_locales.nome LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @hotels = @hotels.where(id: HotelCategory.where(categoria_id: params[:categories]).pluck(:produtos_hospedagem_fornecedor_id).uniq) if params[:categories].present?
  end

  def filter_hotels
    @hotels = @hotels.where('produtos_hospedagem_fornecedores_locales.nome LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @hotels = @hotels.where(id: HotelFacility.where(facilitie_id: params[:facilities]).pluck(:produtos_hospedagem_fornecedor_id).uniq) if params[:facilities].present?
    @hotels = @hotels.where('distancia_do_centro >= ? and distancia_do_centro <= ?', params[:distance].split(',').first, params[:distance].split(',').last) if params[:distance].present?
    @hotels = @hotels.where('numero_de_apartamentos >= ? and numero_de_apartamentos <= ?', params[:rooms].split(',').first, params[:rooms].split(',').last) if params[:rooms].present?
    @hotels = @hotels.where(regime_id: params[:meal]) if params[:meal].present?
  end
end
