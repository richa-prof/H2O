# frozen_string_literal: true

class ItineraryTourExtra < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_passeio_secundarios'

  belongs_to :itinerary_tour, foreign_key: 'loja_fisica_pedido_passeio_id'
  belongs_to :tour_extra, foreign_key: 'produtos_passeiosecundarios_id'
end
