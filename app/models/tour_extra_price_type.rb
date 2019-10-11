# frozen_string_literal: true

class TourExtraPriceType < ApplicationRecord
  self.table_name = 'produtos_passeiosecundarios_tarifas_tipos'

  has_many :tour_extra_price_type_locales, foreign_key: 'produtos_passeiosecundarios_tarifas_tipo_id'
end
