FactoryBot.define do
  factory :session_cart_count do
    date_recorded { Date.current }
    date_count    { 1 }
  end
end
