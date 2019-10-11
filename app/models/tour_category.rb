# frozen_string_literal: true

class TourCategory < ApplicationRecord
  self.table_name = 'produto_categorias'

  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :category, foreign_key: 'categoria_id'
end
