# frozen_string_literal: true

class InstitutionalLocale < ApplicationRecord
  self.table_name = 'institucionais_locales'

  has_paper_trail

  scope :pt_br_only, -> { where(locale: 'pt-BR') }
  scope :en_us_only, -> { where(locale: 'en-US') }

  belongs_to :institutional, foreign_key: 'institucionai_id'

  has_one_attached :image
  attr_accessor :remove_image
  after_save { image.purge if remove_image == '1' }

  def locale_enum
   Locale.list
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    parent Institutional
    list do
      sort_by :locale, :titulo, :titulo_menu
      scopes [:pt_br_only, :en_us_only, :all]
      include_fields :locale, :titulo, :titulo_menu
    end
    edit do
      field :institutional do
        required true
      end
      field :locale do
        required true
      end
      field :titulo do
        required true
      end
      field :titulo_menu do
        required true
      end
      field :metatag_titulo do
        required true
        help 'Obrigatório. Ideal: 60 caracteres.'
      end
      field :metatag_descricao do
        required true
        help 'Obrigatório. Ideal: 160 caracteres.'
      end
      field :texto do
        required true
      end
      field :image, :active_storage
    end
    show do
      include_fields :titulo, :titulo_menu, :metatag_titulo, :metatag_descricao, :texto, :image
    end
  end
end
