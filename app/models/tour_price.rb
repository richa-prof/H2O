# frozen_string_literal: true

class TourPrice < ApplicationRecord
  self.table_name = 'produtos_passeiotarifas'

  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :tour_price_type, foreign_key: 'produtos_passeiotarifas_tipo_id'
end
