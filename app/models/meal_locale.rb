# frozen_string_literal: true

class MealLocale < ApplicationRecord
  self.table_name = 'regimes_locales'

  belongs_to :meal, foreign_key: 'regime_id'
end
