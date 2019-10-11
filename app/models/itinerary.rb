# frozen_string_literal: true

class Itinerary < ApplicationRecord
  self.table_name = 'loja_fisica_pedidos'

  scope :display, -> { order('fim_da_viagem DESC') }

  belongs_to :user, foreign_key: 'usuario_id'
  belongs_to :cart, foreign_key: 'carrinho_id', optional: true
  has_many :paxs, primary_key: 'id', foreign_key: 'loja_fisica_pedido_id'
  has_many :itinerary_tours, primary_key: 'id', foreign_key: 'loja_fisica_pedido_id'
  has_many :itinerary_logs, primary_key: 'id', foreign_key: 'loja_fisica_pedido_id'
  has_many :itinerary_hotels, primary_key: 'id', foreign_key: 'loja_fisica_pedido_id'
end
