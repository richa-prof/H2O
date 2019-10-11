# frozen_string_literal: true

class HotelReservationsManager
  def initialize cart
    @cart = cart
    @api = HotelsAPIWrapper.new

    @availability = {}
    @availability[:status] = false
    @availability[:problem_hotel_id] = ''
  end

  def check_availability
    if @cart.cart_hotels.blank?
      @availability[:status] = true
    else
      @cart.cart_hotels.each do |cart_hotel|
        children_ages = cart_hotel.children_ages.split(' ').map{ |age| age.to_i }

        guest_count = [{
          total: (cart_hotel.adults + children_ages.size),
          adults: cart_hotel.adults,
          children: children_ages.size,
          children_ages: children_ages
        }]

        availability_request_info = {
          guest_count: guest_count,
          hotel_id: cart_hotel.hotel.hotels_api_code,
          start_date: cart_hotel.start_date.strftime('%Y-%m-%d'),
          end_date: cart_hotel.end_date.strftime('%Y-%m-%d')
        }

        availability = HotelsAPIWrapper.new.availability availability_request_info
        room_rates = availability['room_rates']

        if room_rates&.key?(cart_hotel.room_selected)
          @availability[:status] = true
          cart_hotel.update(request_echo_token: availability['request_echo_token'])
        else
          @availability[:status] = false
          @availability[:problem_hotel_id] = cart_hotel.hotel.id
          break
        end
      end
    end

    @availability
  end
end
