class SearchHistory < ApplicationRecord

  scope :search_box_autocomplete, -> (locale, search_term) {
    where('number_of_results > 0 AND locale LIKE ? AND searched_term LIKE ?', locale, "%#{search_term}%").order(number_of_results: :desc, updated_at: :desc).limit(10)
  }

  scope :pt_br_only, -> { where(locale: 'pt-BR') }
  scope :en_us_only, -> { where(locale: 'en-US') }
  scope :no_results, -> { where(number_of_results: 0) }

  rails_admin do
    list do
      sort_by :number_of_results, :updated_at, :number_of_times
      scopes [:all, :pt_br_only, :en_us_only, :no_results]
      field :locale
      field :searched_term
      field :number_of_results do
        sort_reverse true
      end
      field :updated_at do
        sort_reverse true
      end
      field :number_of_times
    end
    show do
      include_fields :locale, :searched_term, :number_of_results, :updated_at, :number_of_times
    end
  end
end
