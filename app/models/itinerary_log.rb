# frozen_string_literal: true

class ItineraryLog < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_logs'

  belongs_to :itinerary, foreign_key: 'loja_fisica_pedido_id'
end
