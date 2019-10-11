# frozen_string_literal: true

class BannerLocale < ApplicationRecord
  has_paper_trail

  scope :pt_br_only, -> { where(locale: 'pt-BR') }
  scope :en_us_only, -> { where(locale: 'en-US') }

  belongs_to :banner, foreign_key: 'banner_id'

  def locale_enum
   Locale.list
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    parent Banner
    list do
      sort_by :banner, :locale, :titulo, :subtitulo
      scopes [:all, :pt_br_only, :en_us_only]
      include_fields :banner, :locale, :titulo, :subtitulo
    end
    edit do
      field :banner do
        required true
      end
      field :locale do
        required true
      end
      field :titulo
      field :subtitulo
      field :texto
      field :link
    end
    show do
      include_fields :banner, :locale, :titulo, :subtitulo, :texto, :link
    end
  end
end
