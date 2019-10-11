# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body:
          { "dados": {
            "head": {
              "servico": 'reserva_salva_lote',
              "chave": '1234abcd'
            },
            "data": [{
              "pre_reserva": '1',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": '0',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller CA 555',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }]
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
                  "nome": 'Ross Geller CA 555',
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
              "servico": 'reserva_salva_lote',
              "chave": '1234abcd'
            },
            "data": [{
              "pre_reserva": '1',
              "cdgbtms_atrativo": '7777777777777777',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": '0',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller CA 555',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }]
          } }.to_json).to_return(
            status: 200,
            body: {
              "info": [
                {
                  "registros": '0',
                  "cdg_erro": '0',
                  "msg": '(102) Não há vagas suficientes a partir deste horário ! 14'
                }
              ],
              "reserva_invalida": {
                "pre_reserva": '1',
                "cdgbtms_atrativo": '7777777777777777',
                "cdgbtms_atividade": '9900880077006600',
                "cdgbtms_agencia": '90550101000830005',
                "cdg_tabela": '',
                "bloqueio": '',
                "reserva_num": '',
                "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                "hora": '13:00',
                "nome": 'Ross Geller CA 555',
                "adt": 3,
                "chd": 1,
                "free": 2,
                "alm_adt": 0,
                "alm_chd": 0,
                "alm_free": 0,
                "observacoes": '',
                "cdg_tipo_transporte": '3'
              },
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
              "servico": 'reserva_salva_lote',
              "chave": '1234abcd'
            },
            "data": [{
              "pre_reserva": '1',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": '0',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Ross Geller CA 55',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 5,
              "alm_chd": 9,
              "alm_free": 7,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }]
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
                  "nome": 'Ross Geller CA 55',
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
              "servico": 'reserva_salva_lote',
              "chave": '1234abcd'
            },
            "data": [
              {
                "pre_reserva": '1',
                "cdgbtms_atrativo": '5500440033002200',
                "cdgbtms_atividade": '9900880077006600',
                "cdgbtms_agencia": '90550101000830005',
                "cdg_tabela": '',
                "bloqueio": '',
                "reserva_num": '0',
                "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                "hora": '13:00',
                "nome": 'Ross Geller CA 55',
                "adt": 3,
                "chd": 1,
                "free": 2,
                "alm_adt": 5,
                "alm_chd": 9,
                "alm_free": 7,
                "observacoes": '',
                "cdg_tipo_transporte": '3'
              },
              {
                "pre_reserva": '1',
                "cdgbtms_atrativo": '5500440033002200',
                "cdgbtms_atividade": '9900880077006601',
                "cdgbtms_agencia": '90550101000830005',
                "cdg_tabela": '',
                "bloqueio": '',
                "reserva_num": '0',
                "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                "hora": '13:00',
                "nome": 'Ross Geller CA 55',
                "adt": 3,
                "chd": 1,
                "free": 2,
                "alm_adt": 0,
                "alm_chd": 0,
                "alm_free": 0,
                "observacoes": '',
                "cdg_tipo_transporte": '3'
              }
            ]
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
                  "nome": 'Ross Geller CA 55',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": 'ABCXYZ',
                  "msg": ''
                },
                {
                  "cdgbtms_atrativo": '5500440033002200',
                  "cdgbtms_atividade": '9900880077006601',
                  "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
                  "hora": '18:00',
                  "nome": 'Ross Geller CA 55',
                  "adt": '3',
                  "chd": '1',
                  "free": '2',
                  "registros": '1',
                  "reserva_num": 'DEFXYZ',
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
              "servico": 'reserva_salva_lote',
              "chave": '1234abcd'
            },
            "data": [{
              "pre_reserva": '1',
              "cdgbtms_atrativo": '5500440033002200',
              "cdgbtms_atividade": '9900880077006600',
              "cdgbtms_agencia": '90550101000830005',
              "cdg_tabela": '',
              "bloqueio": '',
              "reserva_num": '0',
              "data": (Date.current + 3.days).strftime('%d/%m/%Y'),
              "hora": '13:00',
              "nome": 'Donna Roberta Paulsen CA 828',
              "adt": 3,
              "chd": 1,
              "free": 2,
              "alm_adt": 0,
              "alm_chd": 0,
              "alm_free": 0,
              "observacoes": '',
              "cdg_tipo_transporte": '3'
            }]
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
                  "nome": 'Donna Roberta Paulsen CA 828',
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
