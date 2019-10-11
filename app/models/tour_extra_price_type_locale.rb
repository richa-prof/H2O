# frozen_string_literal: true

class TourExtraPriceTypeLocale < ApplicationRecord
  self.table_name = 'produtos_passeiosecundarios_tarifas_tipos_locales'

  belongs_to :tour_extra_price_type, foreign_key: 'produtos_passeiosecundarios_tarifas_tipo_id'
end
