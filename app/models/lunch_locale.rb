# frozen_string_literal: true

class LunchLocale < ApplicationRecord
  self.table_name = 'almoco_locales'

  belongs_to :lunch, foreign_key: 'almoco_id'
end
