# frozen_string_literal: true

class HotelFacility < ApplicationRecord
  self.table_name = 'produtos_hospedagem_fornecedor_facilities'

  belongs_to :hotel, foreign_key: 'produtos_hospedagem_fornecedor_id'
  belongs_to :facility, foreign_key: 'facilitie_id'
end
