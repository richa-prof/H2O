# frozen_string_literal: true

class Cart < ApplicationRecord
  self.table_name = 'carrinhos'

  belongs_to :user, foreign_key: 'usuario_id'
  belongs_to :cupon, foreign_key: 'cupom_id', optional: true

  has_many :cart_passengers, foreign_key: 'carrinho_id'
  has_many :cart_items, foreign_key: 'carrinho_id'
  has_many :cart_tour_extras, foreign_key: 'cart_id'
  has_many :cart_hotels, foreign_key: 'cart_id'

  has_one :itinerary, foreign_key: 'carrinho_id'

  scope :in_process, -> {
    includes(:itinerary, cart_items: [:cart, tour: [tour_facilities: [:facility]]]).where('loja_fisica_pedidos.id IS NULL').references(:itinerary)
  }

  scope :converted, -> {
    includes(:itinerary).where('loja_fisica_pedidos.id IS NOT NULL').references(:itinerary)
  }

  accepts_nested_attributes_for :cart_passengers, allow_destroy: true, reject_if: proc { |attributes| attributes['nome'].blank? || attributes['idade'].blank? || attributes['doc'].blank? }

  def has_btms_items?
    self.cart_items.where(tour_system: 'BTMS').any?
  end

  def has_stock_items?
    self.cart_items.where('tour_system IS NOT NULL AND tour_system <> "BTMS"').any?
  end

  def clear_past_items
    self.cart_items.where('passeio_data < ?', Date.current).destroy_all
  end

  def refresh_tour_prices
    self.clear_past_items
    self.reload

    self.cart_items.each do |cart_item|
      tour_price = cart_item.tour.check_price cart_item.passeio_data

      if tour_price.blank?
        cart_item.tour.tour_extras.where(id: cart_item.cart.cart_tour_extras.pluck(:tour_extra_id)).each do |tour_extra|
          cart_item.cart.cart_tour_extras.where(tour_extra_id: tour_extra.id).first.destroy
        end
        cart_item.destroy
      else
        cart_item.preco_adulto = tour_price.preco_adulto if cart_item.preco_adulto != tour_price.preco_adulto
        cart_item.preco_crianca = tour_price.preco_crianca if cart_item.preco_crianca != tour_price.preco_crianca
        cart_item.preco_crianca2 = tour_price.preco_crianca2 if cart_item.preco_crianca2 != tour_price.preco_crianca2

        cart_item.preco_total = 0
        cart_item.preco_total += (cart_item.preco_adulto.presence || 0) * (cart_item.qtde_adulto.presence || 0)
        cart_item.preco_total += (cart_item.preco_crianca.presence || 0) * (cart_item.qtde_crianca.presence || 0)
        cart_item.preco_total += (cart_item.preco_crianca2.presence || 0) * (cart_item.qtde_crianca2.presence || 0)

        cart_item.tour.tour_extras.where(id: cart_item.cart.cart_tour_extras.pluck(:tour_extra_id)).each do |tour_extra|
          cart_tour_extra = cart_item.cart.cart_tour_extras.where(tour_extra_id: tour_extra.id).first
          tour_extra_price = tour_extra.check_price cart_item.passeio_data

          if tour_extra_price.blank?
            cart_tour_extra.destroy
          else
            cart_item.preco_total += (tour_extra_price.preco_adulto.presence || 0) * (cart_tour_extra.adults_qty.presence || 0)
            cart_item.preco_total += (tour_extra_price.preco_crianca.presence || 0) * (cart_tour_extra.children_qty.presence || 0)
            cart_item.preco_total += (tour_extra_price.preco_crianca2.presence || 0) * (cart_tour_extra.children2_qty.presence || 0)
            cart_item.preco_total += (tour_extra_price.preco_unidade.presence || 0) * (cart_tour_extra.unit_qty.presence || 0)
          end
        end

        cart_item.save
      end
    end
  end

  def add_all_prices
    ( self.cart_items.sum(:preco_total) + self.cart_hotels.sum(:sale_price) ).round(2)
  end

  def refresh_totals
    self.refresh_tour_prices

    refreshed_total = self.add_all_prices
    self.update(subtotal: refreshed_total, total: refreshed_total - self.desconto.to_f)
    self.reload
  end
end
