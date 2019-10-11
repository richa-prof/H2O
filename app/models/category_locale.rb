# frozen_string_literal: true

class CategoryLocale < ApplicationRecord
  self.table_name = 'catlocales'

  has_many :cat_locales, foreign_key: 'catlocale_id'
  has_many :categories, through: :cat_locales
end
