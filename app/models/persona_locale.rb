# frozen_string_literal: true

class PersonaLocale < ApplicationRecord
  self.table_name = 'personas_locales'

  belongs_to :persona, foreign_key: 'persona_id'
end
