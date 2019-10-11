class TourStockDate < ApplicationRecord
  self.table_name = 'produto_subvariacoes'

  scope :display, -> { order(:subvariacao) }
  scope :available_on_date, ->(selected_date) { where( 'status NOT LIKE "Excluido" AND estoque > 0 AND subvariacao LIKE ?', selected_date.strftime("%d/%m/%Y") ) }

  belongs_to :tour_stock_time, foreign_key: 'produto_variacao_id'
end
