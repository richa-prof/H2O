# frozen_string_literal: true

class SpecialDealsController < ApplicationController
  def index
    @special_deals = SpecialDeal.display_on_index
  end

  def show
    @special_deal = SpecialDeal.includes(hotel: [hotel_facilities: [:facility]], special_deal_tours: [tour: [:images_attachments, :lunch, :child]], special_deal_personas: [:persona], special_deal_brings: [:bring], special_deal_incluis: [:inclui]).where(link: params[:id]).first

    redirect_to search_path(search_box: params[:id]), status: :not_found if @special_deal.blank?
  end
end
