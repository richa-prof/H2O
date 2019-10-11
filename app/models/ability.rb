# frozen_string_literal: true

class Ability < ApplicationRecord
  self.table_name = 'abilidades'

  scope :display_on_webiste, -> { order(:ordem) }

  scope :filter_options, -> (locale) {
    includes(:ability_locales).where(abilidade_locales: {locale: locale}).references(:ability_locales)
  }

  has_many :tours, primary_key: 'id', foreign_key: 'abilidade_id'
  has_many :ability_locales, primary_key: 'id', foreign_key: 'abilidade_id'

  rails_admin do
    visible false
  end
end
