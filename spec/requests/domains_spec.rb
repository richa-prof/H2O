# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'domain redirects' do
  it 'from raw domain' do
    get 'https://h2oecoturismo.com.br/'
    expect(response).to redirect_to 'https://www.h2oecoturismo.com.br/'
  end

  it 'from raw domain in the same place' do
    tour = create(:tour, :with_locales, link: 'this-tour')

    get 'https://h2oecoturismo.com.br/passeios/this-tour'
    expect(response).to redirect_to 'https://www.h2oecoturismo.com.br/passeios/this-tour'
  end

  it 'from eventos subdomain' do
    get 'https://eventos.h2oecoturismo.com.br/'
    expect(response).to redirect_to 'https://www.h2oecoturismo.com.br/'
  end

  it 'from blog subdomain' do
    get 'https://blog.h2oecoturismo.com.br/'
    expect(response).to redirect_to 'https://www.h2oecoturismo.com.br/'
  end
end
