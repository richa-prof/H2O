# frozen_string_literal: true

class HotelLocale < ApplicationRecord
  self.table_name = 'produtos_hospedagem_fornecedores_locales'

  belongs_to :hotel, foreign_key: 'produtos_hospedagem_fornecedore_id'
end
