# frozen_string_literal: true

class TourExtraPrice < ApplicationRecord
  self.table_name = 'produtos_passeiosecundarios_tarifas'

  belongs_to :tour_extra, foreign_key: 'produtos_passeiosecundario_id'
end
