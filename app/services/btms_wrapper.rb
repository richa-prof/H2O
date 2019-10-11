# frozen_string_literal: true

class BTMSWrapper
  def initialize
    @chave = authenticate
  end

  def check_tour_availability tour, date_selected
    return false unless (tour.class.to_s == 'Tour') && (date_selected.class.to_s == 'Date')

    tour_info = {
      "data": date_selected.strftime('%d/%m/%Y'),
      "cdgbtms_atrativo": tour.cdgbtms_atrativo,
      "cdgbtms_atividade": tour.cdgbtms_atividade
    }

    post_to_wsbtms 'horarios_atividade', tour_info
  end

  private

  def post_to_wsbtms btms_service, data_info
    head_info = { "servico": btms_service, "chave": @chave.to_s }
    info_to_post = { "dados": { "head": head_info, "data": data_info } }

    begin
      response = RestClient.post 'http://btms.com.br/ws/wsbtms.php', info_to_post.to_json
    rescue Exception => e
      MyVeryOwnLog.create(authoring_class: 'BTMSWrapper',
                          authoring_method: 'post_to_wsbtms',
                          authoring_user_email: '',
                          info: "#{btms_service} => #{e.inspect}")
    end

    JSON.parse(response.body)
  end

  def authenticate
    btms_credentials = {
      "empresa": 'ls turismo',
      "login": 'site.h2o.ror.front.end',
      "senha": '00153446'
    }

    info_returned = post_to_wsbtms 'autenticacao', btms_credentials

    info_returned['dados']['btms']['chave']
  end
end
