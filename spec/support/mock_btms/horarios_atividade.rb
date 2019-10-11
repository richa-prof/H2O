# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body: hash_including(
        { 'dados': {
          'head': {
            'servico': 'horarios_atividade',
            'chave': '1234abcd'
          },
          'data': {
            'data': Date.current.strftime('%d/%m/%Y'),
            'cdgbtms_atrativo': '5500440033002200',
            'cdgbtms_atividade': '9900880077006600'
          }
        } }.to_json
      )).to_return(
        status: 200,
        body: {
          'info': [{
            'vagas_dia_atividade': '6',
            'registros': '22',
            'num_horarios': '22',
            'lotacao_horario_padrao': '15',
            'cdg_erro': '0'
          }],
          'dados': [[{
            '07:00': '0',
            '11:00': '4'
          }]]
        }.to_json,
        headers: {}
      )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body: hash_including(
        { 'dados': {
          'head': {
            'servico': 'horarios_atividade',
            'chave': '1234abcd'
          },
          'data': {
            'data': (Date.current + 3.days).strftime('%d/%m/%Y'),
            'cdgbtms_atrativo': '5500440033002200',
            'cdgbtms_atividade': '9900880077006600'
          }
        } }.to_json
      )).to_return(
        status: 200,
        body: {
          'info': [{
            'vagas_dia_atividade': '6',
            'registros': '22',
            'num_horarios': '22',
            'lotacao_horario_padrao': '15',
            'cdg_erro': '0'
          }],
          'dados': [[{
            '07:00': '0',
            '11:00': '4'
          }]]
        }.to_json,
        headers: {}
      )

    stub_request(:any, 'http://btms.com.br/ws/wsbtms.php')
      .with(body: hash_including(
        { 'dados': {
          'head': {
            'servico': 'horarios_atividade',
            'chave': '1234abcd'
          },
          'data': {
            'data': (Date.current + 10.years).strftime('%d/%m/%Y'),
            'cdgbtms_atrativo': '5500440033002200',
            'cdgbtms_atividade': '9900880077006600'
          }
        } }.to_json
      )).to_return(
        status: 200,
        body: {
          'info': [{
            'registros': '0',
            'cdg_erro': '-1',
            'msg': 'A data pretendida está além da data limite permitida para este passeio !',
            'num_dias': '1',
            'tempo': '11.3',
            'segundos_restantes': '35999'
          }],
          'knx': [[ 'wwv' ]]
        }.to_json,
        headers: {}
      )
  end
end
