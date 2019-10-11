# frozen_string_literal: true

class Meal < ApplicationRecord
  self.table_name = 'regimes'

  scope :display, -> { order(:ordem) }

  has_many :hotels, primary_key: 'id', foreign_key: 'regime_id'
  has_many :meal_locales, primary_key: 'id', foreign_key: 'regime_id'
end
