# frozen_string_literal: true

class InstitutionalsController < ApplicationController
  def show
    @institutional = Institutional.includes(:institutional_locales).where('institucionais_locales.locale = ? AND tag = ?', params[:locale], params[:id]).references(:institutional_locales).first

    redirect_to root_path, notice: 'sem conteúdo' and return if @institutional.blank?
  end
end
