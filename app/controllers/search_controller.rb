class SearchController < ApplicationController
  def results
    @search_term = params[:search_box]
    if @search_term.blank?
      @special_deals = []
      @tours = []
      @hotels = []
      @events = []
    else
      @special_deals = SpecialDeal.display_in_search_results @search_term
      @tours = Tour.display_in_search_results @search_term, params[:locale]
      @hotels = Hotel.display_in_search_results @search_term, params[:locale]
      @events = Event.display_in_search_results @search_term, params[:locale]
    end

    @number_of_results = @special_deals.size + @tours.size + @hotels.size + @events.size

    unless params[:search_box].blank?
      search_history_record = SearchHistory.where(
        locale: params[:locale], searched_term: params[:search_box].downcase
      ).first_or_create
      search_history_record.number_of_results = @number_of_results
      search_history_record.number_of_times = search_history_record.number_of_times.to_i + 1
      search_history_record.save
    end
  end
end
