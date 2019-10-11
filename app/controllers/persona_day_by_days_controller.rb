# frozen_string_literal: true

class PersonaDayByDaysController < ApplicationController
  def index
    @persona = Persona.friendly.find_by(link: params[:persona_id])
    @persona_locale = PersonaLocale.find_by(persona_id: @persona.id, locale: params[:locale]) unless @persona.blank?

    if @persona.present? && @persona_locale.present?
      @days = @persona.display_day_by_days

      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
      @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : (Date.current + 5.days)

      @adults = params[:adults].presence || 2
    else
      redirect_to personas_path, notice: 'sem conteúdo'
    end
  end
end
