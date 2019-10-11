# frozen_string_literal: true

class ToursController < ApplicationController
  def index
    @date_to_use = Date.current
    @categories = Category.filter_options(params[:locale]).limit(12).joins(:tour_categories).uniq
    @abilities = Ability.filter_options(params[:locale])

    filter_tours
  end

  def show
    @tour = Tour.find_for_show params[:locale], params[:id]

    if @tour.is_a? Tour
      @selected_date = @tour.initial_selected_date

      @tour_facilities = TourFacility.includes(facility: [:facility_locales]).where('produto_id = ? AND facilities_locales.locale = ?', @tour.id, params[:locale]).references(:facility_locales)
      @tour_brings = TourBring.includes(bring: [:bring_locales]).where('produto_id = ? AND bring_locales.locale = ?', @tour.id, params[:locale]).references(:bring_locales)

      @tour_lunch = Lunch.where(id: @tour.almoco_id).includes(:lunch_locales).where('almoco_locales.locale = ?', params[:locale]).references(:lunch_locales).first
      @tour_child = Child.where(id: @tour.crianca_id).includes(:child_locales).where('crianca_locales.locale = ?', params[:locale]).references(:child_locales).first
      @tour_ability = Ability.where(id: @tour.abilidade_id).includes(:ability_locales).where('abilidade_locales.locale = ?', params[:locale]).references(:ability_locales).first

      @related_tours = @tour.related_tours params[:locale]
    else
      redirect_to search_path(search_box: params[:id]), status: :not_found
    end
  end

  def availability_and_price
    if request.format == :js
      @tour = Tour.friendly.find(params[:id])
      @selected_date = check_selected_date_submitted

      @availability = TourAvailabilityChecker.new(@tour, @selected_date).check_this
      @tour_price = @tour.check_price @selected_date
      @tour_extras = @tour.extras_to_display @selected_date, params[:locale]

      expires_in 30.minutes, public: true, must_revalidate: true if Rails.env.production?
    else
      render body: nil, status: 415
    end
  end

  def old_routes_index
    redirect_to tours_path
  end

  def old_routes_show
    redirect_to tour_path(params[:id])
  end

  private

  def check_selected_date_submitted
    return Date.current if params[:selected_date].blank?

    begin
       Date.parse(params[:selected_date])
    rescue ArgumentError
       Date.current
    end
  end

  def filter_tours
    @tours = Tour.display_on_webiste.includes(:tour_locales, :tour_prices, images_attachments: [:blob], tour_facilities: [facility: [:facility_locales]]).where(produtos_locales: {locale: params[:locale]}).references(:tour_locales)

    @tours = @tours.where('produtos_locales.nome NOT LIKE "%test%"')
    @tours = @tours.where('produtos_locales.nome LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @tours = @tours.where(id: TourCategory.where(categoria_id: params[:categories]).pluck(:produto_id).uniq) if params[:categories].present?
    @tours = @tours.where(abilidade_id: params[:ability]) if params[:ability].present?
    @tours = @tours.paginate(page: params[:page], per_page: 12)
  end
end
