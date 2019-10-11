# frozen_string_literal: true

class Block < ApplicationRecord
  self.table_name = 'blocks'

  has_many :persona_day_by_day, foreign_key: 'block_id'
  has_many :block_locales, foreign_key: 'block_id'
end
