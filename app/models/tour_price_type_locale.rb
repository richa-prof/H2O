# frozen_string_literal: true

class TourPriceTypeLocale < ApplicationRecord
  self.table_name = 'produtos_passeiotarifas_tipos_locales'

  belongs_to :tour_price_type, foreign_key: 'produtos_passeiotarifas_tipo_id'
end
