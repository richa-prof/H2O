# frozen_string_literal: true

class AdminType < ApplicationRecord
  self.table_name = 'adm_usuario_perfis'

  has_many :admins, foreign_key: 'adm_usuario_perfil_id'

  rails_admin do
    visible false
  end
end
