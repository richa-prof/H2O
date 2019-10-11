# frozen_string_literal: true

class Admin < ApplicationRecord
  self.table_name = 'adm_usuarios'

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :nome, presence: true
  validates :email, presence: true
  validates :usuario, presence: true, uniqueness: true

  belongs_to :admin_type, foreign_key: 'adm_usuario_perfil_id'

  before_save :ensure_senha_field

  def ensure_senha_field
    self.senha = self.senha || Devise.friendly_token
  end

  def custom_label_method
    "#{self.nome} [#{self.base}]"
  end

  def base_enum
    ['Bonito','Campo Grande','Outra']
  end

  rails_admin do
    visible do
      bindings[:controller].current_admin.admin_type.id < 3
    end
    object_label_method do
      :custom_label_method
    end
    list do
      include_fields :id, :admin_type, :nome, :email, :usuario, :base
    end
    edit do
      field :admin_type do
        required true
      end
      field :nome do
        required true
      end
      field :email do
        required true
      end
      field :usuario do
        required true
      end
      field :base do
        required true
      end
      field :password do
        required true
      end
      field :meta do
        help 'Use ponto no lugar da vírgula. Exemplo: Para "R$ 1,50", coloque "1.50"'
      end
      field :whats
    end
    show do
      field :id
      field :admin_type
      field :nome
      field :email
      field :usuario
      field :base
      field :meta do
        formatted_value do
          bindings[:view].number_to_currency( bindings[:object].meta )
        end
      end
      field :whats
    end
  end
end
