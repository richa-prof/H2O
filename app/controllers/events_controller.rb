# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.display_on_webiste(params[:locale])
    @events = @events.where('events_locales.name LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @events = @events.paginate(page: params[:page], per_page: 12)
    @event_info = Institutional.friendly.find_by(tag: 'eventos')
    @event_info_locale = InstitutionalLocale.find_by(institucionai_id: @event_info.id, locale: params[:locale])
  end

  def show
    @event = Event.find_by(id: params[:id])
    redirect_to root_path, notice: 'Evento não encontrado.' and return if @event.blank?
    @event_locale = EventLocale.find_by(event_id: @event.id, locale: params[:locale])
    redirect_to root_path, notice: 'Evento sem conteúdo neste idioma.' and return if @event_locale.blank?
  end
end
