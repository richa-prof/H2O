# frozen_string_literal: true

class EventLocale < ApplicationRecord
  self.table_name = 'events_locales'

  belongs_to :event, foreign_key: 'event_id'
end
