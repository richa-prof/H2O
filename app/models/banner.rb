# frozen_string_literal: true

class Banner < ApplicationRecord
  has_paper_trail

  scope :display_on_home, ->(locale) { includes(:banner_locales, image_attachment: [:blob]).where('banner_locales.locale = ?', locale).references(:banner_locales).order(:ordem) }

  has_many :banner_locales, foreign_key: 'banner_id'

  has_one_attached :image
  attr_accessor :remove_image
  after_save { image.purge if remove_image == '1' }

  def face_image_url
    if self.image.attached?
      Rails.application.routes.url_helpers.url_for self.image
    else
      'https://admin.h2oecoturismo.com.br/' + self.imagem
    end
  end

  def custom_label_method
    "#{self.tipo}"
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    object_label_method do
      :custom_label_method
    end
    list do
      sort_by :ordem
      include_fields :ordem, :tipo, :image
    end
    edit do
      field :ordem do
        required true
      end
      field :tipo do
        required true
      end
      field :image, :active_storage
    end
    show do
      include_fields :ordem, :tipo, :image
    end
  end
end
