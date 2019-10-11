# frozen_string_literal: true

class TourExtraLocale < ApplicationRecord
  self.table_name = 'produtos_passeiosecundarios_locales'

  belongs_to :tour_extra, foreign_key: 'produtos_passeiosecundario_id'
end
