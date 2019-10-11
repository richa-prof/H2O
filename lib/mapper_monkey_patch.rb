module MapperMonkeypatch
  def map_match(paths, options)
    paths.collect! do |path|
      path.is_a?(String) ? path.sub('/rails/active_storage/', '/images/') : path
    end
    super
  end
end

ActionDispatch::Routing::Mapper.prepend(MapperMonkeypatch)
