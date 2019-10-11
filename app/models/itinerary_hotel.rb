# frozen_string_literal: true

class ItineraryHotel < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_hospedagens'

  belongs_to :itinerary, foreign_key: 'loja_fisica_pedido_id'
  belongs_to :hotel, foreign_key: 'produtos_hospedagem_fornecedore_id'
end
