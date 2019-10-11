# frozen_string_literal: true

class Hotel < ApplicationRecord
  self.table_name = 'produtos_hospedagem_fornecedores'

  extend FriendlyId
  friendly_id :link

  has_paper_trail

  scope :display_on_webiste, -> { where('exibir_site = ?', true).order(:ordem) }

  scope :display_on_webiste_with_locale, ->(locale) {
    includes(:hotel_locales, :images_attachments).where('produtos_hospedagem_fornecedores_locales.locale = ? AND exibir_site = ?', locale, true).references(:hotel_locales).order(:ordem)
  }

  scope :find_for_show, -> (locale, link) {
    includes(:hotel_locales, images_attachments: [:blob], facilities: [:facility_locales])
    .where(
      exibir_site: true,
      link: link,
      produtos_hospedagem_fornecedores_locales: {locale: locale}
    ).references(:hotel_locales)
    .first
  }

  scope :display_in_search_results, -> (search_term, locale) {
    includes(:hotel_locales, :images_attachments).where('(produtos_hospedagem_fornecedores_locales.nome LIKE ? OR produtos_hospedagem_fornecedores_locales.metatag_titulo LIKE ? OR produtos_hospedagem_fornecedores_locales.metatag_descricao LIKE ?) AND (produtos_hospedagem_fornecedores_locales.locale = ? AND exibir_site = ?)', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", locale, true).references(:hotel_locales).order(:ordem).limit(5)
  }

  has_many :hotel_locales, primary_key: 'id', foreign_key: 'produtos_hospedagem_fornecedore_id'
  has_many :hotel_categories, primary_key: 'id', foreign_key: 'produtos_hospedagem_fornecedor_id'
  has_many :categories, through: :hotel_categories
  has_many :hotel_facilities, primary_key: 'id', foreign_key: 'produtos_hospedagem_fornecedor_id'
  has_many :facilities, through: :hotel_facilities
  has_many :special_deals, primary_key: 'id', foreign_key: 'produtos_hospedagem_fornecedor_id'

  belongs_to :meal, foreign_key: 'regime_id'

  has_many_attached :images
  attr_accessor :remove_images
  after_save do
    Array(remove_images).each { |id| images.find_by_id(id).try(:purge) }
  end

  def related_hotels(locale)
    Hotel.display_on_webiste_with_locale(locale).where(id: HotelCategory.where(categoria_id: categories.pluck(:id)).pluck(:produtos_hospedagem_fornecedor_id)).where.not(id: id).sample(6)
  end

  def face_image_url
    if self.images.any?
      Rails.application.routes.url_helpers.url_for(self.images.first.variant(resize: '600x200^'))
    else
      'https://admin.h2oecoturismo.com.br/' + self.imagem_1
    end
  end

  def custom_label_method
    "#{self.nome} - #{self.localidade}"
  end

  def hotels_api_code_enum
    hotels_api_code_enum_array = []
    hotels_api_code_enum_array << ['- selecione -', '*']
    HotelsAPIWrapper.new.list_hotels.each do |hotel_info|
      hotels_api_code_enum_array << [hotel_info['name'], hotel_info['id']]
    end
    hotels_api_code_enum_array
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    object_label_method do
      :custom_label_method
    end
    list do
      sort_by :ordem, :nome, :localidade
      scopes [:display_on_webiste, :all]
      include_fields :id, :nome, :localidade, :images, :ordem, :exibir_site
    end
    edit do
      field :images, :multiple_active_storage
      field :hotels_api_code
    end
    show do
      include_fields :id, :nome, :localidade, :images, :hotels_api_code
    end
  end
end
