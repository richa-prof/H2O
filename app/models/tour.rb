# frozen_string_literal: true

class Tour < ApplicationRecord
  self.table_name = 'produtos'

  extend FriendlyId
  friendly_id :link

  has_paper_trail

  scope :display_on_webiste, -> {
    where(
      exibir_site: true,
      status: true
    ).order(:ordem)
  }

  scope :display_on_webiste_with_locale, -> (locale) {
    includes(:tour_locales, images_attachments: [:blob], tour_facilities: [:facility])
    .where(
      exibir_site: true,
      status: true,
      produtos_locales: {locale: locale}
    ).references(:tour_locales)
    .order(:ordem)
  }

  scope :find_for_show, -> (locale, link) {
    includes(:tour_locales, images_attachments: [:blob])
    .where(
      exibir_site: true,
      status: true,
      link: link,
      produtos_locales: {locale: locale}
    ).references(:tour_locales)
    .first
  }

  scope :display_in_search_results, -> (search_term, locale) {
    includes(:tour_locales, :images_attachments)
    .where(
      exibir_site: true,
      status: true,
      produtos_locales: {locale: locale}
    ).where(
      'produtos_locales.nome LIKE ? OR produtos_locales.metatag_titulo LIKE ? OR produtos_locales.metatag_descricao LIKE ?', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"
    ).references(:tour_locales)
    .order(:ordem)
    .limit(5)
  }

  has_many :tour_locales, primary_key: 'id', foreign_key: 'produto_id'
  has_many :tour_categories, foreign_key: 'produto_id'
  has_many :categories, through: :tour_categories
  has_many :tour_prices, foreign_key: 'produto_id'
  has_many :tour_facilities, primary_key: 'id', foreign_key: 'produto_id'
  has_many :tour_brings, primary_key: 'id', foreign_key: 'produto_id'
  has_many :tour_extras, foreign_key: 'produto_id'
  has_many :tour_stock_times, foreign_key: 'produto_id'
  has_many :tour_stock_dates, through: :tour_stock_times

  belongs_to :lunch, foreign_key: 'almoco_id'
  belongs_to :child, foreign_key: 'crianca_id'
  belongs_to :ability, foreign_key: 'abilidade_id'

  has_many_attached :images
  attr_accessor :remove_images
  after_save do
    Array(remove_images).each { |id| images.find_by_id(id).try(:purge) }
  end

  WHAT_TO_BRING = {"Roupa de Banho"=> "Swimsuit", "Dinheiro"=> "Money", "Protetor Solar"=> "Sunscreen", "Repelente"=> "Repellent", "Tênis"=> "Sneakers", "Chapéu/Boné"=> "Hat Cap", "Toalha"=> "Towel", "Água"=> "Water"}

  FACILITIES = {"Banheiros"=> "Toilets", "Piscina"=> "Pool", "Restaurante"=> "restaurant", "Redário"=> "Redário", "Armários"=> "Cabinets", "Chuveiros"=> "Showers", "Pista de Pouso"=> "Airstrip", "Espreguiçadeiras"=> "Sun loungers"}


  def related_tours(locale)
    Tour.display_on_webiste.includes(:tour_locales, :tour_prices, images_attachments: [:blob]).where('produtos_locales.locale = ? AND produtos_passeiotarifas.inicio <= ? AND produtos_passeiotarifas.fim >= ?', locale, Date.current, Date.current).references(:tour_locales).where(id: TourCategory.where(categoria_id: categories.pluck(:id)).pluck(:produto_id)).where.not(id: id).sample(6)
  end

  def todays_price
    tour_prices.where('inicio <= ? AND fim >= ?', Date.current, Date.current).order('id DESC').first
  end

  def check_price for_this_date
    tour_prices.where('inicio <= ? AND fim >= ?', for_this_date, for_this_date).order('id DESC').first
  end

  def extras_to_display(selected_date, locale)
    tour_extras.display_with_tour(selected_date, locale)
  end

  def btms_ready?
    self.cdgbtms_atrativo.present? && self.cdgbtms_atividade.present?
  end

  def allow_public_btms_communication?
    return false unless self.btms_online
    self.btms_ready?
  end

  def initial_selected_date
    return Date.current unless self.special_date && self.tour_stock_times.any?

    earliest_relevant_date = self.tour_stock_dates.where('produto_subvariacoes.status NOT LIKE "Excluido" AND estoque > 0 AND STR_TO_DATE(subvariacao, "%d/%m/%Y") >= ?', Date.current).pluck(Arel.sql 'STR_TO_DATE(subvariacao, "%d/%m/%Y")').min

    earliest_relevant_date.presence || Date.current
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

  def localidade_enum
   Locality.list
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
      include_fields :id, :nome, :localidade, :images, :ordem, :status, :exibir_site
    end
    edit do
      field :nome do
        required true
      end
      field :link do
        required true
      end
      field :localidade do
        required true
      end
      field :exibir_site
      field :status
      field :lunch
      field :child
      field :ability
      field :images, :multiple_active_storage
    end
    show do
      include_fields :id, :nome, :localidade, :ordem, :status, :exibir_site, :link, :images
    end
  end
end
