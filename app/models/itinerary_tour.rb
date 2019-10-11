# frozen_string_literal: true

class ItineraryTour < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_passeios'

  belongs_to :itinerary, foreign_key: 'loja_fisica_pedido_id'
  belongs_to :tour, foreign_key: 'produto_id'
  has_many   :itinerary_tour_extras, foreign_key: 'loja_fisica_pedido_passeio_id'
end
