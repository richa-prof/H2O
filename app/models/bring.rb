# frozen_string_literal: true

class Bring < ApplicationRecord
  self.table_name = 'brings'

  scope :display, -> { order(:ordem) }

  has_many :bring_locales, primary_key: 'id', foreign_key: 'bring_id'
  has_many :tour_brings, primary_key: 'id', foreign_key: 'bring_id'
  has_many :special_deal_brings, primary_key: 'id', foreign_key: 'bring_id'
end
