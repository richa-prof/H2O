# frozen_string_literal: true

class Lunch < ApplicationRecord
  self.table_name = 'almocos'

  scope :display, -> { order(:ordem) }

  has_many :tours, primary_key: 'id', foreign_key: 'almoco_id'
  has_many :lunch_locales, primary_key: 'id', foreign_key: 'almoco_id'

  rails_admin do
    visible false
  end
end
