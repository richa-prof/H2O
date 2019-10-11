# frozen_string_literal: true

class Persona < ApplicationRecord
  self.table_name = 'personas'
  extend FriendlyId
  friendly_id :link

  scope :display_on_website, -> { order(:ordem) }

  scope :display_on_webiste_with_locale, -> (locale) {
    includes(:persona_locales).where('personas_locales.locale = ?', locale).references(:persona_locales)
  }

  has_many :persona_locales, foreign_key: 'persona_id'
  has_many :special_deal_personas, foreign_key: 'persona_id'
  has_many :persona_day_by_days, foreign_key: 'persona_id'

  def display_day_by_days
    persona_day_by_days.includes(:block, tour: [:lunch, :child, images_attachments: [:blob]]).order('day_order, block_id')
  end
end
