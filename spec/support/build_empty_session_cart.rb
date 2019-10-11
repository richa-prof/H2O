# frozen_string_literal: true

def build_empty_session_cart
  session_cart = { 'tours' => {}, 'hotels' => {} }
  inject_session cart: session_cart
end
