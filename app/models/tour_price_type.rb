# frozen_string_literal: true

class TourPriceType < ApplicationRecord
  self.table_name = 'produtos_passeiotarifas_tipos'

  has_many :tour_prices, primary_key: 'id', foreign_key: 'produtos_passeiotarifas_tipo_id'
  has_many :tour_price_type_locales, primary_key: 'id', foreign_key: 'produtos_passeiotarifas_tipo_id'
end
