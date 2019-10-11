# frozen_string_literal: true

class FacilityLocale < ApplicationRecord
  self.table_name = 'facilities_locales'

  belongs_to :facility, foreign_key: 'facilitie_id'
end
