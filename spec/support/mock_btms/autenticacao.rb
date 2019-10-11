# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body: hash_including(
        { "dados": {
          "head": {
            "servico": 'autenticacao',
            "chave": ''
          },
          "data": {
            "empresa": 'ls turismo',
            "login": 'site.h2o.ror',
            "senha": '12344321'
          }
        } }.to_json
      )).to_return(
        status: 200,
        body: { "dados": { "btms": { "chave": '1234abcd' } } }.to_json,
        headers: {}
      )
  end
end
