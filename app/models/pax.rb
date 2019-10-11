# frozen_string_literal: true

class Pax < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_passageiros'

  scope :display, -> { order('age DESC, nome') }

  belongs_to :itinerary, foreign_key: 'loja_fisica_pedido_id'
end
