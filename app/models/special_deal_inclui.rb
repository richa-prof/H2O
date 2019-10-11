# frozen_string_literal: true

class SpecialDealInclui < ApplicationRecord
  self.table_name = 'special_deal_incluis'

  belongs_to :special_deal, foreign_key: 'special_deal_id'
  belongs_to :inclui, foreign_key: 'inclul_id'
end
