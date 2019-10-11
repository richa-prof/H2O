# frozen_string_literal: true

class PersonasController < ApplicationController
  def index
    @personas = Persona.display_on_webiste_with_locale params[:locale]
  end
end
