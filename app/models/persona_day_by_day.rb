# frozen_string_literal: true

class PersonaDayByDay < ApplicationRecord
  self.table_name = 'persona_day_by_days'

  scope :display_on_website, -> { order('day_order, block_id') }

  belongs_to :persona, foreign_key: 'persona_id'
  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :block, foreign_key: 'block_id'
end
