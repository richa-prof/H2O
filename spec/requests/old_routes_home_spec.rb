# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home old routes management' do
  it 'redirects to home pt-BR index' do
    get '/pt-br'
    expect(response).to redirect_to root_pt_br_path
  end

  it 'redirects to home en-US index' do
    get '/en-us'
    expect(response).to redirect_to root_en_path
  end
end
