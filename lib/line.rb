class Line
  include Serializable
  include CachedRenderTarget
  attr_reader :x, :y, :x2, :y2, :thickness, :color, :cap
  attr_accessor :color, :rotate

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @x2 = args.fetch(:x2, 0)
    @y2 = args.fetch(:y2, 0)
    @thickness = args.fetch(:thickness, 1)
    @color = args.fetch(:color, Color::BLACK)
    @cap = args.fetch(:cap, :none)
    @rotate = args.fetch(:rotate, 0)

    @path = nil

    @offset_x = 0
    @offset_y = 0
    @w = length

    reset_rt
  end

  def length
    @length ||= Math.sqrt((@x2 - @x)**2 + (@y2 - @y)**2)
  end

  def angle
    @angle ||= Math.atan2(@y2 - @y, @x2 - @x).to_degrees
  end

  def x=(val)
    reset_rt if @x != val
    @x = val
  end

  def y=(val)
    reset_rt if @y != val
    @y = val
  end

  def x2=(val)
    reset_rt if @x2 != val
    @x2 = val
  end

  def y2=(val)
    reset_rt if @y2 != val
    @y2 = val
  end

  def thickness=(val)
    reset_rt if @thickness != val
    @thickness = val
  end

  def cap=(val)
    reset_rt if @cap != val
    @cap = val
  end

  def path
    @path ||= "line:#{accuracy_cache_key(length)}:#{accuracy_cache_key(@thickness)}:#{@cap}"
  end

  def to_primitives
    cached_rt(path) { |rt| create_render_target(rt) }

    {
      x: @x + @offset_x,
      y: @y + @offset_y,
      w: @w,
      h: @thickness,
      angle: angle + @rotate,
      angle_anchor_x: @angle_anchor_x,
      angle_anchor_y: @angle_anchor_y,
      path: path
    }.sprite!(@color)
  end

private

  def reset_rt
    @path = nil
    @length = nil
    @angle = nil

    # Sometimes nested RT creation fails, so we ensure the disk is created out of band
    if @cap == :round
      t2 = @thickness / 2
      Disk.new(x: t2, y: t2, radius: t2, color: Color::WHITE).create!
    end
  end

  def create_render_target(rt)
    case @cap
    when :none, :butt
      butt_rt(rt)
    when :round
      round_rt(rt)
    end
  end

  def butt_rt(rt)
    rt.w = @w = length
    rt.h = @thickness
    rt.primitives << {
      x: 0,
      y: 0,
      w: length,
      h: @thickness,
      path: :pixel
    }.sprite!(Color::WHITE)

    @angle_anchor_x = 0
    @angle_anchor_y = 0.5
    @offset_x = 0
    @offset_y = -@thickness / 2
  end

  def round_rt(rt)
    rt.w = @w = length + @thickness
    rt.h = @thickness
    t2 = @thickness / 2

    if length <= 1.0
      rt.primitives << Disk.new(x: t2, y: t2, radius: t2, color: Color::WHITE).to_primitives
    else
      scap = Disk.new(x: t2, y: t2, radius: t2, color: Color::WHITE)
      ecap = Disk.new(x: length + t2, y: t2, radius: t2, color: Color::WHITE)
      rect = {
        x: t2,
        y: 0,
        w: length,
        h: @thickness,
        path: :pixel
      }.sprite!(Color::WHITE)

      rt.primitives << [
        scap.to_primitives,
        rect,
        ecap.to_primitives
      ]
    end

    @angle_anchor_x = t2 / @w
    @angle_anchor_y = 0.5
    @offset_x = -t2
    @offset_y = -t2
  end
end
