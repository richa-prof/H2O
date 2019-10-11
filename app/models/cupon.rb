# frozen_string_literal: true

class Cupon < ApplicationRecord
  self.table_name = 'cupons'

  belongs_to :user, foreign_key: 'usuario_id', optional: true
  has_many :carts, foreign_key: 'cupom_id'
end
