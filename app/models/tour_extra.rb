# frozen_string_literal: true

class TourExtra < ApplicationRecord
  self.table_name = 'produtos_passeiosecundarios'

  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :tour_extra_price_type, foreign_key: 'produtos_passeiosecundarios_tarifas_tipo_id'
  has_many :tour_extra_locales, foreign_key: 'produtos_passeiosecundario_id'
  has_many :tour_extra_prices, foreign_key: 'produtos_passeiosecundario_id'
  has_many :cart_tour_extras, foreign_key: 'tour_extra_id'
  has_many :itinerary_tour_extras, foreign_key: 'produtos_passeiosecundarios_id'

  scope :display_with_tour, ->(selected_date, locale) { includes(:tour_extra_prices, :tour_extra_locales).where('inicio <= ? AND fim >= ? AND locale = ?', selected_date, selected_date, locale).references(:tour_extra_prices, :tour_extra_locales) }

  def check_price for_this_date
    tour_extra_prices.where('inicio <= ? AND fim >= ?', for_this_date, for_this_date).order('id DESC').first
  end
end
