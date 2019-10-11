# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'general old routes management' do
  it 'redirects to tour show' do
    tour = create(:tour, link: 'first-tour')
    category = create(:category, link: 'first-category')
    institutional = create(:institutional, tag: 'first-institutional')

    get '/first-tour'
    expect(response).to redirect_to tour_path(tour)

    get '/pt-br/first-tour'
    expect(response).to redirect_to tour_pt_br_path(tour)

    get '/en-us/first-tour'
    expect(response).to redirect_to tour_en_path(tour)
  end

  it 'redirects to category' do
    tour = create(:tour, link: 'first-tour')
    category = create(:category, link: 'first-category')
    institutional = create(:institutional, tag: 'first-institutional')

    get '/first-category'
    expect(response).to redirect_to category_path(category)

    get '/pt-br/first-category'
    expect(response).to redirect_to category_pt_br_path(category)

    get '/en-us/first-category'
    expect(response).to redirect_to category_en_path(category)
  end

  it 'redirects to institutional' do
    tour = create(:tour, link: 'first-tour')
    category = create(:category, link: 'first-category')
    institutional = create(:institutional, tag: 'first-institutional')

    get '/first-institutional'
    expect(response).to redirect_to institutional_path(institutional)

    get '/pt-br/first-institutional'
    expect(response).to redirect_to institutional_pt_br_path(institutional)

    get '/en-us/first-institutional'
    expect(response).to redirect_to institutional_en_path(institutional)
  end

  it 'informs 404 status and redirects' do
    tour = create(:tour, link: 'first-tour')
    category = create(:category, link: 'first-category')
    institutional = create(:institutional, tag: 'first-institutional')

    link_to_redirect_pt = 'http://www.example.com/busca?search_box=first-something-else'
    link_to_redirect_en = 'http://www.example.com/en/search?search_box=first-something-else'

    get '/first-something-else'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_pt + '">redirected</a>'

    get '/pt-br/first-something-else'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_pt + '">redirected</a>'

    get '/en-us/first-something-else'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_en + '">redirected</a>'
  end
end
