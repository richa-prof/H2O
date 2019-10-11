# frozen_string_literal: true

class TourFacility < ApplicationRecord
  self.table_name = 'produto_facilities'

  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :facility, foreign_key: 'facilitie_id'
  has_many :facility_locales, through: :facility
end
