# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_confirma',
              "chave": '1234abcd'
            },
            "data": [{
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "reserva_num": 'ABCXYZ'
            }]
          } }.to_json).to_return(
            status: 200,
            body: {
              "0": [
                [
                  {
                    "reserva_num": '296553',
                    "registros": '1',
                    "cdg_erro": '0',
                    "msg": ''
                  }
                ]
              ],
              "registros": '1',
              "knx": [
                [
                  'suX'
                ]
              ]
            }.to_json,
            headers: {}
          )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_confirma',
              "chave": '1234abcd'
            },
            "data": [{
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "reserva_num": '654321'
            }]
          } }.to_json).to_return(
            status: 200,
            body: {
              "0": [
                [
                  {
                    "reserva_num": '654321',
                    "registros": '1',
                    "cdg_erro": '0',
                    "msg": ''
                  }
                ]
              ],
              "registros": '1',
              "knx": [
                [
                  'suX'
                ]
              ]
            }.to_json,
            headers: {}
          )
  end
end
