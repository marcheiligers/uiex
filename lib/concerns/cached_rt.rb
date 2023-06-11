module CachedRenderTarget
  CACHE = {}
  @@accuracy = 4

  def self.accuracy
    @@accuracy
  end

  def self.accuracy=(val)
    @@accuracy = val
  end

  def accuracy_cache_key(val)
    "#{@@accuracy}!#{(val * @@accuracy).round}"
  end

  def cached_rt(path, &block)
    CACHE[path] ||= begin
      $args.render_target(path).tap do |rt|
        block.call(rt)
      end
    end
  end
end
