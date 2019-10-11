# frozen_string_literal: true

class HotelCategory < ApplicationRecord
  self.table_name = 'produtos_hospedagem_fornecedor_categorias'

  belongs_to :hotel, foreign_key: 'produtos_hospedagem_fornecedor_id'
  belongs_to :category, foreign_key: 'categoria_id'
end
