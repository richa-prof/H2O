# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'categories redirects management' do
  it 'redirects to locale search' do
    link_to_redirect_pt = 'http://www.example.com/busca?search_box='
    link_to_redirect_en = 'http://www.example.com/en/search?search_box='

    get '/categorias/some-category'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_pt + 'some-category">redirected</a>'

    get '/en/categories/some-category'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_en + 'some-category">redirected</a>'

    create(:category, link: 'first-category')

    get '/categorias/first-category'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_pt + 'first-category">redirected</a>'

    get '/en/categories/first-category'
    expect(response.status).to eq 404
    expect(response.body).to include '<a href="' + link_to_redirect_en + 'first-category">redirected</a>'
  end
end
