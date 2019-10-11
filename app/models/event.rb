# frozen_string_literal: true

class Event < ApplicationRecord
  self.table_name = 'events'

  scope :display_on_home, ->(locale) { includes(:event_locales).where('events_locales.locale = ? AND events.end_date >= ?', locale, Date.current).references(:event_locales).sample(2) }

  scope :display_on_webiste, ->(locale) { includes(:event_locales).where('events_locales.locale = ?', locale).references(:event_locales).order('start_date DESC') }

  scope :display_in_search_results, -> (search_term, locale) {
    includes(:event_locales).where('(events_locales.name LIKE ? OR events_locales.description LIKE ?) AND (events_locales.locale = ?)', "%#{search_term}%", "%#{search_term}%", locale).references(:event_locales).order('start_date DESC').limit(5)
  }

  has_many :event_locales, primary_key: 'id', foreign_key: 'event_id'
end
