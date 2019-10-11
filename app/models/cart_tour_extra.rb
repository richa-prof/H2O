# frozen_string_literal: true

class CartTourExtra < ApplicationRecord
  belongs_to :cart, foreign_key: 'cart_id'
  belongs_to :tour_extra, foreign_key: 'tour_extra_id'
end
