module CachedRenderTarget
  CACHE = {}

  def cached_rt(path, &block)
    CACHE[path] ||= begin
      $args.render_target(path).tap do |rt|
        block.call(rt)
      end
    end
  end
end
