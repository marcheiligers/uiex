class Line
  include Serializable
  include CachedRenderTarget
  attr_reader :x, :y, :x2, :y2, :thickness, :color, :cap

  def initialize(**args) # x0, y0, x1, y1, thickness)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @x2 = args.fetch(:x2, 0)
    @y2 = args.fetch(:y2, 0)
    @thickness = args.fetch(:thickness, 1)
    @color = args.fetch(:color, Color::BLACK)
    @cap = args.fetch(:cap, :none)

    @path = nil

    @offset_x = 0
    @offset_y = 0
    @w = length
  end

  def length
    @length ||= Math.sqrt((@x2 - @x)**2 + (@y2 - @y)**2)
  end

  def angle
    @angle ||= Math.atan2(@y2 - @y, @x2 - @x).to_degrees
  end

  def x=(val)
    reset_rt
    @x = val
  end

  def y=(val)
    reset_rt
    @y = val
  end

  def x2=(val)
    reset_rt
    @x2 = val
  end

  def y2=(val)
    reset_rt
    @y2 = val
  end

  def thickness=(val)
    reset_rt
    @thickness = val
  end

  def color=(val)
    @color = val
  end

  def cap=(val)
    reset_rt
    @cap = val
  end

  def to_primitives
    @path ||= "line:#{accuracy_cache_key(length)}:#{accuracy_cache_key(@thickness)}:#{@cap}"
    cached_rt(@path) { |rt| create_render_target(rt) }

    x = {
      x: @x + @offset_x,
      y: @y + @offset_y - @thickness / 2,
      w: @w,
      h: @thickness,
      angle: angle,
      angle_anchor_x: @angle_anchor_x,
      angle_anchor_y: @angle_anchor_y,
      path: @path
    }.sprite!(@color)
    # puts x
    x
  end

private

  def reset_rt
    @path = nil
    @length = nil
    @angle = nil
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
    rt.w = length
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
    @offset_y = 0
    @w = length
  end

  def round_rt(rt)
    rt.w = length + @thickness
    rt.h = @thickness

    t2 = @thickness / 2
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

    @angle_anchor_x = t2.fdiv(rt.w)
    @angle_anchor_y = 0.5
    @offset_x = -t2
    @offset_y = 0
    @w = length + @thickness
  end
end
