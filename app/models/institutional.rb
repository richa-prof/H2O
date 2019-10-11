# frozen_string_literal: true

class Institutional < ApplicationRecord
  self.table_name = 'institucionais'

  extend FriendlyId
  friendly_id :tag

  has_paper_trail

  scope :on_footer_menu, -> { where('exibir_menu = ?', true) }

  scope :footer_menu, ->(locale) {
    includes(:institutional_locales).where('exibir_menu = ? AND institucionais_locales.locale = ?', true, locale).references(:institutional_locales).order(:titulo)
  }

  has_many :staff, foreign_key: 'institucionai_id'
  has_many :institutional_locales, foreign_key: 'institucionai_id'
  has_many :testimonials, foreign_key: 'institucionai_id'
  has_many :questions, foreign_key: 'institucionai_id'

  def custom_label_method
    "#{self.tag} - #{self.titulo}"
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    object_label_method do
      :custom_label_method
    end
    list do
      sort_by :tag, :titulo
      scopes [:on_footer_menu, :all]
      include_fields :tag, :titulo, :exibir_menu
    end
    edit do
      field :tag do
        required true
      end
      field :titulo do
        required true
      end
      field :exibir_menu do
        required true
      end
    end
    show do
      include_fields :tag, :titulo, :exibir_menu
    end
  end
end
