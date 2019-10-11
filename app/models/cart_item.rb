# frozen_string_literal: true

class CartItem < ApplicationRecord
  self.table_name = 'carrinho_itens'

  belongs_to :cart, foreign_key: 'carrinho_id'
  belongs_to :tour, foreign_key: 'produto_id'
end
