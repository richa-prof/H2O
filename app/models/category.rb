# frozen_string_literal: true

class Category < ApplicationRecord
  self.table_name = 'categorias'
  extend FriendlyId
  friendly_id :link

  scope :display_on_list, -> (locale) {
    includes(:cat_locales, :category_locales)
    .where(
      exibir_site: true,
      catlocales: {locale: locale}
    )
    .references(:category_locales)
    .order(:ordem)
  }

  scope :filter_options, -> (locale) {
    includes(:cat_locales, :category_locales)
    .where(
      destaque: true,
      exibir_site: true,
      catlocales: {locale: locale}
    )
    .references(:category_locales)
    .order(:ordem)
  }

  has_many :tour_categories, foreign_key: 'categoria_id'
  has_many :tours, through: :tour_categories

  has_many :hotel_categories, foreign_key: 'categoria_id'
  has_many :hotels, through: :hotel_categories

  has_many :cat_locales, foreign_key: 'categoria_id'
  has_many :category_locales, through: :cat_locales

  rails_admin do
    list do
      include_fields :id, :nome, :link, :ordem, :exibir_site
    end
    edit do
      include_fields :id, :nome, :link, :ordem, :exibir_site
    end
    show do
      include_fields :id, :nome, :link, :ordem, :exibir_site
    end
  end
end
