# frozen_string_literal: true

class Question < ApplicationRecord
  self.table_name = 'duvidas'

  default_scope { order(:ordem) }

  belongs_to :institutional, foreign_key: 'institucionai_id'
end
