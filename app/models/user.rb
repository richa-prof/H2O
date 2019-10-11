# frozen_string_literal: true

class User < ApplicationRecord
  self.table_name = 'usuarios'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :carts, foreign_key: 'usuario_id'
  has_many :cupons, foreign_key: 'usuario_id'
  has_many :itineraries, foreign_key: 'usuario_id'
  has_many :old_ols, foreign_key: 'usuario_id'

  validates :nome, presence: true

  def converted_carts
    carts.converted.order('data DESC')
  end

  def cart_in_process
    carts.in_process.order('carrinhos.data DESC').first
  end

  protected

  def confirmation_required?
    false
  end
end
