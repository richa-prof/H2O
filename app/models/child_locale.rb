# frozen_string_literal: true

class ChildLocale < ApplicationRecord
  self.table_name = 'crianca_locales'

  belongs_to :child, foreign_key: 'crianca_id'
end
