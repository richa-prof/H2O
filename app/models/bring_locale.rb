# frozen_string_literal: true

class BringLocale < ApplicationRecord
  self.table_name = 'bring_locales'

  belongs_to :what_to_bring, foreign_key: 'bring_id'
end
