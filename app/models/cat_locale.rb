# frozen_string_literal: true

class CatLocale < ApplicationRecord
  self.table_name = 'catlocale_categorias'

  belongs_to :category, foreign_key: 'categoria_id'
  belongs_to :category_locale, foreign_key: 'catlocale_id'
end
