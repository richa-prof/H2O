# frozen_string_literal: true

class Facility < ApplicationRecord
  self.table_name = 'facilities'

  scope :display, -> { order(:ordem) }

  has_many :facility_locales, primary_key: 'id', foreign_key: 'facilitie_id'
  has_many :tour_facilities, primary_key: 'id', foreign_key: 'facilitie_id'
  has_many :hotel_facilities, primary_key: 'id', foreign_key: 'facilitie_id'
end
