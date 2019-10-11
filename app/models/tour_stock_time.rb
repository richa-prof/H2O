class TourStockTime < ApplicationRecord
  self.table_name = 'produto_variacoes'

  scope :display_on_website, -> { order(:variacao) }
  scope :active, -> { where('status NOT LIKE "Excluido"') }
  scope :available_on_date, ->(selected_date) { joins(:tour_stock_dates).where( 'produto_variacoes.status NOT LIKE "Excluido" AND produto_subvariacoes.status NOT LIKE "Excluido" AND estoque > 0 AND subvariacao LIKE ?', selected_date.strftime("%d/%m/%Y") ) }

  belongs_to :tour, foreign_key: 'produto_id'

  has_many :tour_stock_dates, foreign_key: 'produto_variacao_id'
end
