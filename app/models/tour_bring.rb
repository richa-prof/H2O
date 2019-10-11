# frozen_string_literal: true

class TourBring < ApplicationRecord
  self.table_name = 'produto_brings'

  belongs_to :tour, foreign_key: 'produto_id'
  belongs_to :bring, foreign_key: 'bring_id'
  has_many :bring_locales, through: :bring
end
