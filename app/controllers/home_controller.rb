# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @banners = Banner.display_on_home(params[:locale])

    @personas = Persona.display_on_webiste_with_locale params[:locale]
    @start_date = Date.current
    @end_date = Date.current + 5.days
    @adults = 2

    @special_deals = SpecialDeal.display_on_home

    @tours = Tour.display_on_webiste_with_locale(params[:locale]).limit(8)

    @hotels = Hotel.display_on_webiste_with_locale(params[:locale]).limit(2)

    @events = Event.display_on_home params[:locale]

    @testimonials = Testimonial.display_on_home

    if params[:locale] == 'en-US'
      @meta_description = 'Everything you need to prepare an amazing trip to Bonito, to the Pantanal, or to any other place in Mato Grosso do Sul, Brazil! Tours, transportation services, hotels, inns, packages, special deals, tips, suggestions, recommendations, an online platform, and so much more!'
    else
      @meta_description = 'Tudo que você precisa para a sua viagem para Bonito MS, Pantanal Sul, ou qualquer outro lugar do Mato Grosso do Sul ser inesquecível! Passeios, transporte, hotéis, pousadas, pacotes, ofertas, promoções, dicas, sugestões, recomendações, compra online e muito mais!'
    end
  end

  def old_routes_index
    redirect_to root_path
  end
end
