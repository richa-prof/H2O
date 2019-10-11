# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tour old routes management' do
  it 'redirects to tour pt-BR index' do
    get '/pt-br/loja'
    expect(response).to redirect_to tours_pt_br_path
  end

  it 'redirects to tour en-US index' do
    get '/en-us/loja'
    expect(response).to redirect_to tours_en_path
  end

  it 'redirects to tour pt-BR show' do
    tour = create(:tour, link: 'first-tour')

    get '/pt-br/servico/first-tour'
    expect(response).to redirect_to tour_pt_br_path(tour)
  end

  it 'redirects to tour en-US show' do
    tour = create(:tour, link: 'first-tour')

    get '/en-us/servico/first-tour'
    expect(response).to redirect_to tour_en_path(tour)
  end
end
