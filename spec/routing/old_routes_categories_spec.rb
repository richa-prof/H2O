# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'category old routes management' do
  it 'routes to categories pt-BR show' do
    category = create(:category, :with_pt_br_locale, link: 'first-category')

    expect(get: '/pt-br/loja/first-category').to route_to(
      controller: 'categories',
      action: 'show',
      id: 'first-category',
      locale: 'pt-BR'
    )
  end

  it 'routes to categories en-US show' do
    category = create(:category, :with_locale, link: 'first-category')

    expect(get: '/en-us/loja/first-category').to route_to(
      controller: 'categories',
      action: 'show',
      id: 'first-category',
      locale: 'en'
    )
  end
end
