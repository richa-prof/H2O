# frozen_string_literal: true

class BlockLocale < ApplicationRecord
  self.table_name = 'block_locales'

  belongs_to :block, foreign_key: 'block_id'
end
