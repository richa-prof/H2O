# frozen_string_literal: true

def build_session_cart_with_hotel
  hotel = create(:hotel, :pt_br)

  session_cart = {
    'tours' => {},
    'hotels' => {
      hotel.id.to_s => {
        'request_echo_token' => '_h2o_token_0987654321',
        'start_date' => '14/05/2050',
        'end_date' => '16/05/2050',
        'adults' => '2',
        'children_ages' => [],
        'number_of_nights' => '2',
        'room_type_name' => 'Mega Hiper Luxuoso',
        'room_selected' => '1234-5678-0',
        'sale_price' => '9.99'
      }
    }
  }

  inject_session cart: session_cart
end
