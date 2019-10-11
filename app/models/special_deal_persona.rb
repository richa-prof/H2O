# frozen_string_literal: true

class SpecialDealPersona < ApplicationRecord
  self.table_name = 'special_deal_personas'

  belongs_to :special_deal, foreign_key: 'special_deal_id'
  belongs_to :persona, foreign_key: 'persona_id'
end
