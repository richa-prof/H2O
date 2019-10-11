# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :correct_domain
  before_action :correct_locale
  before_action :set_menu_info
  before_action :set_paper_trail_whodunnit

  require 'rest-client'

  def set_menu_info
    @institutionals = Institutional.footer_menu(params[:locale])
    @contact_us = @institutionals.where(tag: 'contato').first
  end

  def user_for_paper_trail
    current_admin.present? ? current_admin.id : 'some non admin spy'
  end

  def old_routes_general
    @tour = Tour.friendly.find_by(link: params[:url])
    redirect_to tour_path @tour and return if @tour.present?

    @category = Category.friendly.find_by(link: params[:url])
    redirect_to category_path @category and return if @category.present?

    @institutional = Institutional.friendly.find_by(tag: params[:url])
    redirect_to institutional_path @institutional and return if @institutional.present?

    redirect_to search_path(search_box: params[:url]), status: :not_found
  end

  protected

  def correct_domain
    if '//h2o'.in? request.original_url
      redirect_to request.url.sub('//h2o', '//www.h2o')
    end
    if '//eventos.'.in? request.original_url
      redirect_to request.url.sub('//eventos.', '//www.')
    end
    if '//blog.'.in? request.original_url
      redirect_to request.url.sub('//blog.', '//www.')
    end
  end

  def correct_locale
    params[:locale] = 'en-US' if params[:locale] == 'en'
  end
end
