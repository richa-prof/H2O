if @search_histories.any?
  json.array!(@search_histories) do |search_history|
    json.searched_term search_history.searched_term
  end
else
  no_results_hash = {
    searched_term: ''
  }
  no_results_array = [no_results_hash]
  json.array!(no_results_array) do |no_result|
    json.searched_term no_result[:searched_term]
  end
end
