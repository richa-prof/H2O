# frozen_string_literal: true

class Child < ApplicationRecord
  self.table_name = 'criancas'

  scope :display, -> { order(:ordem) }

  has_many :tours, primary_key: 'id', foreign_key: 'crianca_id'
  has_many :child_locales, primary_key: 'id', foreign_key: 'crianca_id'

  rails_admin do
    visible false
  end
end
