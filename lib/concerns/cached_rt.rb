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
      rt = $args.render_target(path)
      block.call(rt)
      {
        w: rt.w,
        h: rt.h,
        rt: rt
      }
    end
  end
end
