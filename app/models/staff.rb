# frozen_string_literal: true

class Staff < ApplicationRecord
  self.table_name = 'equipes'

  belongs_to :institutional, foreign_key: 'institucionai_id'
  has_many :staff_locales, primary_key: 'id', foreign_key: 'equipe_id'
end
