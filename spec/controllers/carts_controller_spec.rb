# frozen_string_literal: true

require 'rails_helper'

describe CartsController do
  describe 'when a person has an old session cart' do
    it 'should reset the cart to a new one' do
      old_session_cart = { '5' => { 'tour_selected_date' => '14/05/2055',
                                    'tour_selected_time' => '05:04',
                                    'tour_adults' => '5',
                                    'tour_children' => '3',
                                    'tour_children2' => '1',
                                    'tour_final_price' => '555.55',
                                    'tour_extra' => [],
                                    'tour_extra_persons' => [] } }

      get :add_to_cart, params: { locale: 'pt-BR' }, session: { cart: old_session_cart }

      expect( session[:cart] ).to eq( { 'tours' => {}, 'hotels' => {} } )
    end
  end

  describe 'when a person adds a tour to their cart' do
    it 'should add tour to session cart' do
      tour = create(:tour)
      tour_date = Date.current.strftime('%d/%m/%Y')
      tour_time = '13:00'

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => tour_date,
            'tour_selected_time' => tour_time,
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :add_to_cart,
          params: { locale: 'pt-BR',
                    tour_id: tour.id,
                    tour_selected_date: tour_date,
                    tour_selected_time: tour_time,
                    tour_system: 'BTMS',
                    tour_adults: 3,
                    tour_children: 0,
                    tour_children2: 0,
                    tour_final_price: 90 },
          session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect( session[:cart] ).to eq session_cart
      expect( session[:cart]['tours'].count ).to eq 1
      expect( session[:cart]['hotels'].count ).to eq 0
    end

    it 'should use stock info in session cart' do
      tour = create(:tour)
      tour_date = Date.current.strftime('%d/%m/%Y')
      tour_stock_time = create(:tour_stock_time, tour: tour, status: 'Ativo', variacao: '12:45')
      tour_stock_date = create(:tour_stock_date, tour_stock_time: tour_stock_time, status: 'Ativo', subvariacao: tour_date)

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => tour_stock_date.subvariacao,
            'tour_selected_time' => tour_stock_time.variacao,
            'tour_system' => tour_stock_date.id.to_s,
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :add_to_cart,
          params: { locale: 'pt-BR',
                    tour_id: tour.id,
                    tour_selected_date: tour_stock_date.subvariacao,
                    tour_selected_time: tour_stock_time.variacao,
                    tour_system: tour_stock_date.id.to_s,
                    tour_adults: 3,
                    tour_children: 0,
                    tour_children2: 0,
                    tour_final_price: 90 },
          session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect( session[:cart] ).to include session_cart
      expect( session[:cart]['tours'].count ).to eq 1
    end

    it 'should increment session cart count' do
      tour = create(:tour)
      tour_date = Date.current.strftime('%d/%m/%Y')
      tour_time = '13:00'

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => tour_date,
            'tour_selected_time' => tour_time,
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :add_to_cart,
          params: { locale: 'pt-BR',
                    tour_id: tour.id,
                    tour_selected_date: tour_date,
                    tour_selected_time: tour_time,
                    tour_system: 'BTMS',
                    tour_adults: 3,
                    tour_children: 0,
                    tour_children2: 0,
                    tour_final_price: 90 },
          session: {}

      expect( SessionCartCount.count ).to eq 1
      expect( SessionCartCount.first.date_recorded ).to eq Date.current
      expect( SessionCartCount.first.date_count ).to eq 1
    end

    it 'should not increment session cart count for existing carts' do
      tour = create(:tour)
      tour_date = Date.current.strftime('%d/%m/%Y')
      tour_time = '13:00'

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => tour_date,
            'tour_selected_time' => tour_time,
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :add_to_cart,
          params: { locale: 'pt-BR',
                    tour_id: tour.id,
                    tour_selected_date: tour_date,
                    tour_selected_time: tour_time,
                    tour_system: 'BTMS',
                    tour_adults: 3,
                    tour_children: 0,
                    tour_children2: 0,
                    tour_final_price: 90 },
          session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect( SessionCartCount.count ).to eq 0
      expect( SessionCartCount.first ).to eq nil
    end
  end

  describe 'when a person removes a tour from their cart' do
    it 'should remove the item from session cart' do
      session_cart = {
        'tours' => {
          '1' => {
            'tour_selected_date' => Date.current.strftime('%d/%m/%Y'),
            'tour_selected_time' => '13:00',
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :remove_from_cart,
          params: { locale: 'pt-BR', id: '1', item_class: 'Tour' },
          session: { cart: session_cart }

      expect( flash[:notice] ).to match 'Item removido com sucesso'
      expect( session[:cart]['tours'].count ).to eq 0
    end

    it 'should remove the item from cart object' do
      tour = create(:tour)
      user = create(:user)
      cart = create(:cart, user: user)
      create(:cart_item, tour: tour, cart: cart)

      sign_in user

      expect do
        get :remove_from_cart,
            params: { locale: 'pt-BR', id: tour.id.to_s, item_class: 'Tour' },
            session: { cart: { 'tours' => {}, 'hotels' => {} } }
      end
        .to change { cart.cart_items.count }.by(-1)

      expect( flash[:notice] ).to match 'Item removido com sucesso'
    end
  end

  describe 'when a person adds a hotel to their cart' do
    it 'should add the hotel to session cart' do
      hotel = create(:hotel)

      session_cart = {
        'tours' => {},
        'hotels' => {
          hotel.id.to_s => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => '14/05/2050',
            'end_date' => '16/05/2050',
            'adults' => '2',
            'children_ages' => '',
            'number_of_nights' => '2',
            'room_type_name' => 'Mega Hiper Luxuoso',
            'room_selected' => '1234-5678-0',
            'sale_price' => '9.99'
          }
        }
      }

      get :add_to_cart,
          params: {
            locale: 'pt-BR',
            hotel_id: hotel.id,
            request_echo_token: '_h2o_token_0987654321',
            start_date: '14/05/2050',
            end_date: '16/05/2050',
            adults: 2,
            children_ages: '',
            number_of_nights: 2,
            room_type_name: 'Mega Hiper Luxuoso',
            room_selected: '1234-5678-0',
            sale_price: 9.99
          },
          session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect( session[:cart] ).to eq session_cart
      expect( session[:cart]['tours'].count ).to eq 0
      expect( session[:cart]['hotels'].count ).to eq 1
    end
  end

  describe 'when a person removes a hotel from their cart' do
    it 'should remove the item from session cart' do
      session_cart = {
        'tours' => {},
        'hotels' => {
          '1' => {
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

      get :remove_from_cart,
          params: { locale: 'pt-BR', id: '1', item_class: 'Hotel' },
          session: { cart: session_cart }

      expect( flash[:notice] ).to match 'Item removido com sucesso'
      expect( session[:cart]['hotels'].count ).to eq 0
    end

    it 'should remove hotel from cart object' do
      hotel = create(:hotel)
      user = create(:user)
      cart = create(:cart, user: user)
      create(:cart_hotel, hotel: hotel, cart: cart)

      sign_in user

      expect do
        get :remove_from_cart,
            params: { locale: 'pt-BR', id: hotel.id.to_s, item_class: 'Hotel' },
            session: { cart: { 'tours' => {}, 'hotels' => {} } }
      end
        .to change { cart.cart_hotels.count }.by(-1)

      expect( flash[:notice] ).to match 'Item removido com sucesso'
    end
  end

  describe 'goes on to additional information page' do
    it 'should save session cart tours to cart object' do
      tour = create(:tour)
      create(:tour_price, tour: tour, preco_adulto: 30)

      sign_in create(:user)

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => Date.current.strftime('%d/%m/%Y'),
            'tour_selected_time' => '13:00',
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      expect do
        get :additional_information,
            params: { locale: 'pt-BR' },
            session: { cart: session_cart }
      end
        .to change { Cart.count }.from(0).to(1)
        .and change { CartItem.count }.from(0).to(1)
    end

    it 'should save session cart hotels to cart object' do
      hotel = create(:hotel, id: 1)

      sign_in create(:user)

      session_cart = {
        'tours' => {},
        'hotels' => {
          '1' => {
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

      expect do
        get :additional_information,
            params: { locale: 'pt-BR' },
            session: { cart: session_cart }
      end
        .to change { Cart.count }.from(0).to(1)
        .and change { CartHotel.count }.from(0).to(1)

        expect( CartItem.count ).to be 0
    end

    it 'should use a cart object without itinerary' do
      tour = create(:tour)
      create(:tour_price, tour: tour, preco_adulto: 30)
      user = create(:user)

      cart = create(:cart, :converted, user: user)
      create(:cart_item, cart: cart)

      sign_in user

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => Date.current.strftime('%d/%m/%Y'),
            'tour_selected_time' => '13:00',
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      expect do
        get :additional_information,
            params: { locale: 'pt-BR' },
            session: { cart: session_cart }
      end
        .to change { Cart.count }.from(1).to(2)
        .and change { CartItem.count }.from(1).to(2)
        .and change { user.carts.count }.from(1).to(2)

      expect(user.converted_carts.count).to eq 1
      expect(user.cart_in_process.id).to eq Cart.second.id
      expect(CartItem.second.carrinho_id).to eq Cart.second.id
    end

    it 'should register if availability came from BTMS' do
      tour = create(:tour)
      create(:tour_price, tour: tour, preco_adulto: 30)

      sign_in create(:user)

      session_cart = {
        'tours' => {
          tour.id.to_s => {
            'tour_selected_date' => Date.current.strftime('%d/%m/%Y'),
            'tour_selected_time' => '13:00',
            'tour_system' => 'BTMS',
            'tour_adults' => 3.to_s,
            'tour_children' => 0.to_s,
            'tour_children2' => 0.to_s,
            'tour_final_price' => 90.to_s,
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {}
      }

      get :additional_information, params: { locale: 'pt-BR' }, session: { cart: session_cart }

      expect( CartItem.first.tour_system ).to eq 'BTMS'
    end
  end

  describe 'collects additional information' do
    it 'should update information in cart without itinerary' do
      user = create(:user)

      previous_cart = create(:cart, :converted, user: user, localizacao: 'not me')
      create(:cart_item, cart: previous_cart)

      cart_to_use = create(:cart, user: user, localizacao: nil)
      create(:cart_item, cart: cart_to_use)

      info_input = { localizacao: 'use me instead',
                     cart_passengers_attributes: [] }

      sign_in user

      expect do
        put :update,
            params: { locale: 'pt-BR',
                      id: cart_to_use.id,
                      cart: info_input,
                      telefone: '1234-1234' },
            session: { cart: { 'tours' => {}, 'hotels' => {} } }
      end
        .to change { Cart.second.localizacao }.from(nil).to('use me instead')
        .and change { User.first.telefone }.from(nil).to('1234-1234')

      expect(Cart.first.localizacao).to eq 'not me'
    end

    it 'should create cart passengers' do
      user = create(:user)
      cart = create(:cart, :with_item, user: user)

      cart_passengers_attributes = [{ nome: 'Marcelo Madureira', idade: '25', doc: 'RG 234' },
                                    { nome: 'Cláudio Manuel', idade: '33', doc: 'CPF 987' }]

      info_input = { cart_passengers_attributes: cart_passengers_attributes }

      sign_in user

      expect do
        put :update,
            params: { locale: 'pt-BR',
                      id: cart.id,
                      cart: info_input },
            session: { cart: { 'tours' => {}, 'hotels' => {} } }
      end
        .to change { CartPassenger.count }.from(0).to(2)

      expect(CartPassenger.first.nome).to eq 'Marcelo Madureira'
      expect(CartPassenger.first.idade).to eq 25

      expect(CartPassenger.second.nome).to eq 'Cláudio Manuel'
      expect(CartPassenger.second.idade).to eq 33
    end
  end

  describe 'when promocode is submitted' do
    login_user

    it 'should make sure there is a code' do
      create(:cupon, chave: 'this-fun-cupon')
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: nil, id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).not_to be_present
      expect(Cart.first.subtotal).to eq cart.subtotal
      expect(Cart.first.desconto).to eq cart.desconto
      expect(Cart.first.total).to eq cart.total
      expect(Cart.first.cupom_id).to eq 0
    end

    it 'should inform if not valid' do
      create(:cupon, chave: 'this-fun-cupon')
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'some-other-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Promocode inválido'
    end

    it 'should work for the right user' do
      create(:cupon, chave: 'this-fun-cupon', usuario_id: controller.current_user.id)
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Promocode aplicado à compra.'
    end

    it 'should not work for wrong user' do
      create(:cupon, chave: 'this-fun-cupon', usuario_id: (controller.current_user.id + 1))
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Promocode inválido'
    end

    it 'should inform if cupon is expired' do
      create(:cupon, chave: 'this-fun-cupon', vencimento: Date.current - 3.days)
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Este promocode já venceu.'
    end

    it 'should inform if cupon has reached its limit' do
      create(:cupon, chave: 'this-fun-cupon', limite: 1, vezes_usado: 1)
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'O limite de uso deste promocode já foi atingido.'
    end

    it 'inform success for percentage type' do
      create(:cupon, chave: 'this-fun-cupon', tipo: 'Porcentagem')
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Promocode aplicado à compra.'
    end

    it 'inform success for brl type' do
      create(:cupon, chave: 'this-fun-cupon', tipo: 'BRL')
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Promocode aplicado à compra.'
    end

    it 'inform success for other types' do
      create(:cupon, chave: 'this-fun-cupon', tipo: 'Some Very Special Prize')
      cart = create(:cart, :with_item_and_pax, user: controller.current_user)

      post :check_promocode,
           params: { locale: 'pt-BR', cupom_id: 'this-fun-cupon', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect(flash[:notice]).to match 'Parabéns! Você ganhou um brinde! Some Very Special Prize'
    end

    it 'calculates and saves cart total' do
      cart = create(:cart, :with_pax, user: controller.current_user)

      tour_a = create(:tour)
      create(:tour_price, tour: tour_a, preco_adulto: 1)

      tour_b = create(:tour)
      create(:tour_price, tour: tour_b, preco_adulto: 3)

      create(:cart_item, cart: cart, tour: tour_a, qtde_adulto: 1, qtde_crianca: 0, qtde_crianca2: 0)
      create(:cart_item, cart: cart, tour: tour_b, qtde_adulto: 2, qtde_crianca: 0, qtde_crianca2: 0)

      get :payment,
           params: { locale: 'pt-BR', id: cart.id.to_s },
           session: { cart: { 'tours' => {}, 'hotels' => {} } }

      expect( Cart.first.total ).to eq 7
    end
  end

  describe 'when clearing old cart items' do
    it 'clears them away completely' do
      session_cart = {
        'tours' => {
          '1' => {
            'tour_selected_date' => '14/05/1984',
            'tour_selected_time' => '05:04',
            'tour_system' => 'BTMS',
            'tour_adults' => '3',
            'tour_children' => '0',
            'tour_children2' => '0',
            'tour_final_price' => '0',
            'tour_extra' => nil,
            'tour_extra_persons' => {}
          }
        },
        'hotels' => {
          '1' => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => '14/05/1984',
            'end_date' => '16/05/1984',
            'adults' => '2',
            'children_ages' => [],
            'number_of_nights' => '2',
            'room_type_name' => 'Mega Hiper Luxuoso',
            'room_selected' => '1234-5678-0',
            'sale_price' => '9.99'
          }
        }
      }

      get :add_to_cart, params: { locale: 'pt-BR' }, session: { cart: session_cart }

      expect( session[:cart] ).to eq( { 'tours' => {}, 'hotels' => {} } )
    end

    it 'deals with invalid dates' do
      session_cart = {
        'tours' => {
          '3' => {
            'tour_selected_date' => '14/00/2050',
            'tour_selected_time' => '05:04',
            'tour_adults' => '5',
            'tour_children' => '3',
            'tour_children2' => '1',
            'tour_final_price' => '555.55',
            'tour_extra' => [],
            'tour_extra_persons' => []
          },
          '7' => {
            'tour_selected_date' => '14/05/198',
            'tour_selected_time' => '05:04',
            'tour_adults' => '5',
            'tour_children' => '3',
            'tour_children2' => '1',
            'tour_final_price' => '555.55',
            'tour_extra' => [],
            'tour_extra_persons' => []
          },
          '9' => {
            'tour_selected_date' => '',
            'tour_selected_time' => '05:04',
            'tour_adults' => '5',
            'tour_children' => '3',
            'tour_children2' => '1',
            'tour_final_price' => '555.55',
            'tour_extra' => [],
            'tour_extra_persons' => []
          },
          '11' => {
            'tour_selected_date' => nil,
            'tour_selected_time' => '05:04',
            'tour_adults' => '5',
            'tour_children' => '3',
            'tour_children2' => '1',
            'tour_final_price' => '555.55',
            'tour_extra' => [],
            'tour_extra_persons' => []
          }
        },
        'hotels' => {
          '1' => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => '14/00/2050',
            'end_date' => '16/05/2050',
            'adults' => '2',
            'children_ages' => [],
            'number_of_nights' => '2',
            'room_type_name' => 'Mega Hiper Luxuoso',
            'room_selected' => '1234-5678-0',
            'sale_price' => '9.99'
          },
          '3' => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => '14/05/205',
            'end_date' => '16/05/2050',
            'adults' => '2',
            'children_ages' => [],
            'number_of_nights' => '2',
            'room_type_name' => 'Mega Hiper Luxuoso',
            'room_selected' => '1234-5678-0',
            'sale_price' => '9.99'
          },
          '7' => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => '',
            'end_date' => '16/05/2050',
            'adults' => '2',
            'children_ages' => [],
            'number_of_nights' => '2',
            'room_type_name' => 'Mega Hiper Luxuoso',
            'room_selected' => '1234-5678-0',
            'sale_price' => '9.99'
          },
          '9' => {
            'request_echo_token' => '_h2o_token_0987654321',
            'start_date' => nil,
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

      get :add_to_cart, params: { locale: 'pt-BR' }, session: { cart: session_cart }

      expect( session[:cart] ).to eq( { 'tours' => {}, 'hotels' => {} } )
    end

    it 'deals with missing cart' do
      sign_in create(:user)
      get :additional_information, params: { locale: 'pt-BR' }

      expect( session[:cart] ).to be_nil
    end
  end
end
