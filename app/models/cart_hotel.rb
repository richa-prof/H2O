class CartHotel < ApplicationRecord
  belongs_to :cart
  belongs_to :hotel
end
