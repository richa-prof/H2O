# frozen_string_literal: true

class AbilityLocale < ApplicationRecord
  self.table_name = 'abilidade_locales'

  belongs_to :ability, foreign_key: 'abilidade_id'
end
