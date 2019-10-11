# frozen_string_literal: true

class Testimonial < ApplicationRecord
  self.table_name = 'depoimentos'

  default_scope { where(status: 'ativo').order('created desc') }

  scope :display_on_home, -> { limit(25) }

  belongs_to :institutional, foreign_key: 'institucionai_id'
end
