require 'rails_helper'

describe SearchController do
  describe 'GET results' do
    it 'returns matching records' do
      yes_me = create(:tour_locale, :pt_br, nome: 'Coolest thing you could ever possibly do!')
      not_me = create(:tour_locale, :pt_br, nome: 'Same old boring stuff.')

      get :results, params: { locale: 'pt-BR', search_box: 'possibly' }

      expect( response ).to render_template 'results'
      expect( assigns(:tours) ).to include yes_me.tour
      expect( assigns(:tours) ).not_to include not_me.tour
    end

    it 'creates SearchHistory records' do
      create(:tour_locale, :pt_br, nome: 'Coolest thing you could ever possibly do!')

      expect do
        get :results, params: { locale: 'pt-BR', search_box: 'possibly' }
      end
      .to change{ SearchHistory.count }.by(1)

      expect( SearchHistory.first.searched_term ).to eq 'possibly'
      expect( SearchHistory.first.number_of_results ).to eq 1
    end

    it 'updates existing matching SearchHistory records' do
      create(:search_history, locale: 'pt-BR', searched_term: 'possibly', number_of_results: 5)
      create(:tour_locale, :pt_br, nome: 'Coolest thing you could ever possibly do!')
      create(:tour_locale, :pt_br, nome: 'Coolest thing you could ever possibly do!')

      expect do
        get :results, params: { locale: 'pt-BR', search_box: 'possibly' }
      end
      .to change{ SearchHistory.count }.by(0)
      .and change{ SearchHistory.first.number_of_results }.from(5).to(2)
    end

    it 'increments number_of_times in existing matching SearchHistory record' do
      create(:search_history, locale: 'pt-BR', searched_term: 'possibly', number_of_times: 7)

      expect do
        get :results, params: { locale: 'pt-BR', search_box: 'possibly' }
      end
      .to change{ SearchHistory.first.number_of_times }.from(7).to(8)
    end
  end
end
