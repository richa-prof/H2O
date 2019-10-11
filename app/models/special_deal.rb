# frozen_string_literal: true

class SpecialDeal < ApplicationRecord
  self.table_name = 'special_deals'

  extend FriendlyId
  friendly_id :link

  has_paper_trail

  scope :display_on_webiste, -> { where('display_end_date > ?', Date.current).order(:start_date) }

  scope :display_on_home, -> { includes(thumbnail_image_attachment: [:blob]).where('display_end_date > ?', Date.current).order(:start_date) }

  scope :display_on_index, -> { includes(special_deal_personas: [:persona], thumbnail_image_attachment: [:blob]).where('display_end_date > ?', Date.current).order(:start_date) }

  scope :display_in_search_results, -> (search_term) {
    includes(thumbnail_image_attachment: [:blob]).where('(name LIKE ? OR tag_line LIKE ?) AND (display_end_date > ?)', "%#{search_term}%", "%#{search_term}%", Date.current).order(:start_date).limit(5)
  }

  has_many :special_deal_personas, primary_key: 'id', foreign_key: 'special_deal_id'
  has_many :special_deal_tours, primary_key: 'id', foreign_key: 'special_deal_id'
  has_many :special_deal_brings, primary_key: 'id', foreign_key: 'special_deal_id'
  has_many :special_deal_incluis, primary_key: 'id', foreign_key: 'special_deal_id'

  has_one_attached :thumbnail_image
  attr_accessor :remove_thumbnail_image
  after_save { thumbnail_image.purge if remove_thumbnail_image == '1' }

  has_one_attached :background_image
  attr_accessor :remove_background_image
  after_save { background_image.purge if remove_background_image == '1' }

  belongs_to :hotel, foreign_key: 'produtos_hospedagem_fornecedor_id', optional: true

  def cover_image_url
    if self.thumbnail_image.attached?
      Rails.application.routes.url_helpers.url_for self.thumbnail_image.variant(resize: '600x200^')
    else
      'https://admin.h2oecoturismo.com.br/' + self.photo_home
    end
  end

  def background_image_url
    if self.background_image.attached?
      Rails.application.routes.url_helpers.url_for self.background_image
    else
      'https://admin.h2oecoturismo.com.br/' + self.photo_page
    end
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    list do
      sort_by :name, :start_date, :display_start_date
      scopes [:display_on_webiste, :all]
      include_fields :name, :start_date, :display_start_date, :thumbnail_image, :background_image
    end
    edit do
      field :thumbnail_image, :active_storage
      field :background_image, :active_storage
    end
    show do
      include_fields :name, :thumbnail_image, :background_image
    end
  end
end
