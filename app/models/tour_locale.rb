# frozen_string_literal: true

class TourLocale < ApplicationRecord
  self.table_name = 'produtos_locales'

  belongs_to :tour, foreign_key: 'produto_id'

  def custom_label_method
    "#{self.locale} - #{self.nome}"
  end

  rails_admin do
    parent Tour
    object_label_method do
      :custom_label_method
    end
    list do
      include_fields :id, :locale, :nome, :metatag_titulo
    end
    edit do
      # include_fields :id, :locale, :nome, :metatag_titulo
    end
    show do
      include_fields :id, :locale, :nome, :metatag_titulo
    end
  end
end
