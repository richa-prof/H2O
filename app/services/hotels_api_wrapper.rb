# frozen_string_literal: true

class HotelsAPIWrapper
  def initialize
    get_token
  end

  def list_hotels
    begin
      response = RestClient.get "#{domain_url}hotels#{url_suffix}"
    rescue Exception => e
      MyVeryOwnLog.create(authoring_class: 'HotelsAPIWrapper',
                          authoring_method: 'list_hotels',
                          authoring_user_email: '',
                          info: e.inspect)
    end

    JSON.parse(response.body)
  end

  def availability request_info, primary_language = 'pt-BR'
    request_url = "#{domain_url}availability#{url_suffix}"

    request_info = request_info.merge({ primary_language: primary_language })

    begin
      response = RestClient.post request_url, request_info.to_json, request_headers
    rescue Exception => e
      MyVeryOwnLog.create(authoring_class: 'HotelsAPIWrapper',
                          authoring_method: 'availability',
                          authoring_user_email: '',
                          info: e.inspect)
    end

    parsed_response = response.respond_to?(:body) ? JSON.parse(response.body) : ''
    parsed_response['availability'].presence || 'no availability'
  end

  private

  def get_token
    request_url = "#{domain_url}current_token"
    credentials = { email: 'front-end@email.com', password: 'xcmU9GzrGia3' }.to_json

    begin
      response = RestClient.post request_url, credentials, request_headers
    rescue Exception => e
      MyVeryOwnLog.create(authoring_class: 'HotelsAPIWrapper',
                          authoring_method: 'get_token',
                          authoring_user_email: '',
                          info: e.inspect)
    end

    parsed_response = JSON.parse(response.body)

    @token = parsed_response['current_token']
    @expires_at = DateTime.parse(parsed_response['expires_at'])
  end

  def request_headers
    { content_type: :json, accept: :json }
  end

  def domain_url
    'https://hotels-api.h2oecoturismo.com.br/api/v1/'
  end

  def url_suffix
    "?auth_token=#{@token}"
  end
end
