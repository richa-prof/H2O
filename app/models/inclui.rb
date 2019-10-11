# frozen_string_literal: true

class Inclui < ApplicationRecord
  self.table_name = 'incluis'

  scope :display, -> { order(:ordem) }

  has_many :special_deal_incluis, primary_key: 'id', foreign_key: 'inclul_id'
end
