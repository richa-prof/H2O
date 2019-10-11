# frozen_string_literal: true

class StaffLocale < ApplicationRecord
  self.table_name = 'equipes_locales'

  belongs_to :staff, foreign_key: 'equipe_id'
end
