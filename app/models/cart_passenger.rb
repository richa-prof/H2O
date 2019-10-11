# frozen_string_literal: true

class CartPassenger < ApplicationRecord
  self.table_name = 'carrinho_passageiros'

  belongs_to :cart, foreign_key: 'carrinho_id'
end
