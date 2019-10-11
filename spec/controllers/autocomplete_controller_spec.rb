require 'rails_helper'

describe AutocompleteController do
  describe 'GET search history' do
    it 'returns history' do
      yes_me = create(:search_history, searched_term: 'looking for trouble')
      not_me = create(:search_history, searched_term: 'found some')

      get :search_history, params: { locale: 'pt-BR', search_box: 'for' }

      expect( response ).to render_template 'search_history'
      expect( assigns(:search_histories) ).to include yes_me
      expect( assigns(:search_histories) ).not_to include not_me
    end

    it 'orders by number of results' do
      create(:search_history, searched_term: 'me third', number_of_results: 2)
      create(:search_history, searched_term: 'me first', number_of_results: 12)
      create(:search_history, searched_term: 'me second', number_of_results: 7)

      get :search_history, params: { locale: 'pt-BR', search_box: 'me' }

      expect( assigns(:search_histories).first.searched_term ).to eq 'me first'
      expect( assigns(:search_histories).second.searched_term ).to eq 'me second'
      expect( assigns(:search_histories).third.searched_term ).to eq 'me third'
    end

    it 'hides records with 0 for number of results' do
      yes_me = create(:search_history, searched_term: 'something', number_of_results: 2)
      not_me = create(:search_history, searched_term: 'something else', number_of_results: 0)

      get :search_history, params: { locale: 'pt-BR', search_box: 'some' }

      expect( assigns(:search_histories) ).to include yes_me
      expect( assigns(:search_histories) ).not_to include not_me
    end

    it 'returns most recent first' do
      create(:search_history, searched_term: 'me last')
      sleep 1
      create(:search_history, searched_term: 'me second')
      sleep 1
      create(:search_history, searched_term: 'me first')

      get :search_history, params: { locale: 'pt-BR', search_box: 'me' }

      expect( assigns(:search_histories).first.searched_term ).to eq 'me first'
      expect( assigns(:search_histories).second.searched_term ).to eq 'me second'
      expect( assigns(:search_histories).third.searched_term ).to eq 'me last'
    end

    it 'hides records with different locale' do
      yes_me = create(:search_history, searched_term: 'something', locale: 'pt-BR')
      not_me = create(:search_history, searched_term: 'something', locale: 'en-US')

      get :search_history, params: { locale: 'pt-BR', search_box: 'some' }

      expect( assigns(:search_histories) ).to include yes_me
      expect( assigns(:search_histories) ).not_to include not_me
    end
  end
end
