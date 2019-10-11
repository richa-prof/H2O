# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_salva',
              "chave": '1234abcd'
            },
            "data": {
              "pre_reserva": '0',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": 'ABCXYZ',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller PD 2',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }
          } }.to_json).to_return(
            status: 200,
            body: {
              "info": [
                {
                  "registros": '1',
                  "cdg_erro": '0',
                  "msg": ''
                }
              ],
              "reservas": [
                {
                  "cdgbtms_atrativo": '5500440033002200',
                  "cdgbtms_atividade": '9900880077006600',
                  "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                  "hora": '13:00',
                  "nome": 'Ross Geller PD 2',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": 'ABCXYZ',
                  "msg": ''
                }
              ],
              "knx": [
                [
                  'm1E'
                ]
              ]
            }.to_json,
            headers: {}
          )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_salva',
              "chave": '1234abcd'
            },
            "data": {
              "pre_reserva": '0',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": 'ABCXYZ',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller PD 1',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }
          } }.to_json).to_return(
            status: 200,
            body: {
              "info": [
                {
                  "registros": '1',
                  "cdg_erro": '0',
                  "msg": ''
                }
              ],
              "reservas": [
                {
                  "cdgbtms_atrativo": '5500440033002200',
                  "cdgbtms_atividade": '9900880077006600',
                  "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                  "hora": '13:00',
                  "nome": 'Ross Geller PD 1',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": 'ABCXYZ',
                  "msg": ''
                }
              ],
              "knx": [
                [
                  'm1E'
                ]
              ]
            }.to_json,
            headers: {}
          )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_salva',
              "chave": '1234abcd'
            },
            "data": {
              "pre_reserva": '0',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": 'ABCXYZ',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller PD 5',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 77,
              "alm_chd": 33,
              "alm_free": 55,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }
          } }.to_json).to_return(
            status: 200,
            body: {
              "info": [
                {
                  "registros": '1',
                  "cdg_erro": '0',
                  "msg": ''
                }
              ],
              "reservas": [
                {
                  "cdgbtms_atrativo": '5500440033002200',
                  "cdgbtms_atividade": '9900880077006600',
                  "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                  "hora": '13:00',
                  "nome": 'Ross Geller PD 5',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": 'ABCXYZ',
                  "msg": ''
                }
              ],
              "knx": [
                [
                  'm1E'
                ]
              ]
            }.to_json,
            headers: {}
          )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_salva',
              "chave": '1234abcd'
            },
            "data": {
              "pre_reserva": '0',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": '654321',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Donna Roberta Paulsen PD 1',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }
          } }.to_json).to_return(
            status: 200,
            body: {
              "info": [
                {
                  "registros": '1',
                  "cdg_erro": '0',
                  "msg": ''
                }
              ],
              "reservas": [
                {
                  "cdgbtms_atrativo": '5500440033002200',
                  "cdgbtms_atividade": '9900880077006600',
                  "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                  "hora": '13:00',
                  "nome": 'Donna Roberta Paulsen PD 1',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": '654321',
                  "msg": ''
                }
              ],
              "knx": [
                [
                  'm1E'
                ]
              ]
            }.to_json,
            headers: {}
          )
  end
end
