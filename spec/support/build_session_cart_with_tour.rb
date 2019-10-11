# frozen_string_literal: true

def build_session_cart_with_tour
  tour = create(:tour, :with_pt_br_locale)
  create(:tour_price, tour: tour, fim: '14/05/2075')
  tour_extra_price_type_person = create(:tour_extra_price_type, :person_pt_br)
  tour_extra_person = create(:tour_extra, :pt_br_with_price, tour: tour, tour_extra_price_type: tour_extra_price_type_person)
  tour_extra_price_type_unit = create(:tour_extra_price_type, :unit_pt_br)
  tour_extra_unit = create(:tour_extra, :pt_br_with_price, tour: tour, tour_extra_price_type: tour_extra_price_type_unit)

  tour_extra = [tour_extra_person.id.to_s, tour_extra_unit.id.to_s]

  tour_extra_persons = {
    tour_extra_person.id.to_s => {
      'adults' => 1,
      'children' => 2,
      'children2' => 3
    },
    tour_extra_unit.id.to_s => {
      'unit' => 1
    }
  }

  session_cart = {
    'tours' => {
      tour.id.to_s => {
        'tour_selected_date' => '14/05/2055',
        'tour_selected_time' => '05:04',
        'tour_adults' => '5',
        'tour_children' => '3',
        'tour_children2' => '1',
        'tour_final_price' => '1000.98',
        'tour_extra' => tour_extra,
        'tour_extra_persons' => tour_extra_persons
      }
    },
    'hotels' => {}
  }

  inject_session cart: session_cart
end
