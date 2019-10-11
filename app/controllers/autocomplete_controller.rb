class AutocompleteController < ApplicationController
  before_action :force_json

  def search_history
    @search_histories = SearchHistory.search_box_autocomplete params[:locale], params[:search_box]
  end

  private

	def force_json
		request.format = :json
	end
end
