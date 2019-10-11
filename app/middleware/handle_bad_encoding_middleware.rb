class HandleBadEncodingMiddleware
  def initialize app
    @app = app
  end

  def call env
    begin
      Rack::Utils.parse_nested_query(env['ORIGINAL_FULLPATH'])
    rescue Rack::Utils::InvalidParameterError
      env['QUERY_STRING'] = ''
      env['ORIGINAL_FULLPATH'] = ''
      env['REQUEST_PATH'] = ''
      env['REQUEST_URI'] = ''
      env['PATH_INFO'] = ''
    end

    @app.call env
  end
end
