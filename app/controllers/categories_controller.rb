# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.display_on_list params[:locale]
    @tours = Tour.display_on_webiste_with_locale(params[:locale]).limit(12)
  end

  def show
    @category = Category.includes(:category_locales).where('categorias.link = ? AND catlocales.locale = ?', params[:id], params[:locale]).references(:category_locales).first
    if @category.present?
      @tours = Tour.display_on_webiste_with_locale(params[:locale]).where(id: TourCategory.where(categoria_id: @category.id).pluck(:produto_id).uniq).includes(tour_facilities: [facility: [:facility_locales]])
      @tours = @tours.paginate(page: params[:page], per_page: 6)

      @hotels = Hotel.display_on_webiste_with_locale(params[:locale]).where(id: HotelCategory.where(categoria_id: @category.id).pluck(:produtos_hospedagem_fornecedor_id).uniq).includes(hotel_facilities: [facility: [:facility_locales]]).where('facilities_locales.locale = ?', params[:locale]).references(:facility_locales)
      @hotels = @hotels.paginate(page: params[:page], per_page: 6)

      @categories = Category.display_on_list params[:locale]
    else
      redirect_to search_path(search_box: params[:id]), status: :not_found
    end
  end
end
