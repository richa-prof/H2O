# frozen_string_literal: true

class SpecialDealTour < ApplicationRecord
  self.table_name = 'special_deal_produtos'

  belongs_to :special_deal, foreign_key: 'special_deal_id'
  belongs_to :tour, foreign_key: 'produto_id'
end
