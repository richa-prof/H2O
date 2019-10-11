# frozen_string_literal: true

class SpecialDealBring < ApplicationRecord
  self.table_name = 'special_deal_brings'

  belongs_to :special_deal, foreign_key: 'special_deal_id'
  belongs_to :bring, foreign_key: 'bring_id'
end
