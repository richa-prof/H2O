# frozen_string_literal: true

class Payment < ApplicationRecord
  self.table_name = 'loja_fisica_pedido_lancamentos'

  scope :display, -> { order('data') }

  belongs_to :itinerary, foreign_key: 'loja_fisica_pedido_id'
end
