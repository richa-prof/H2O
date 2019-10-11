# frozen_string_literal: true

class Location < ApplicationRecord
  self.table_name = 'hoteis'

  scope :display, -> { order(:nome) }
end
