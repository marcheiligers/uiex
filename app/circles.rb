BG = [0, 0, 0].freeze

def tick args
  args.outputs.background_color = BG

  if args.tick_count == 0
    args.state.circle1 = circle(radius: 100, x: 100, y: 100, r: 255, g: 0, b: 0)
    args.state.circle2 = circle(radius: 50, x: 300, y: 500, arc_angle: 300, r: 255, g: 0, b: 255)
  end

  args.outputs.primitives << [
    args.state.circle1,
    args.state.circle2,
    { x: 10, y: 700, text: "#{$state.rt_cache.length}" }.label!(Color::WHITE),
    { radius: 100, x: 310, y: 100 }.circle!(Color::GREEN),
    { radius: 100, x: 520, y: 100, arc_angle: 300, angle: 30 }.circle!(Color::BLUE),
    { radius: 6, x: 640, y: 360 }.circle!(Color::STEEL_BLUE),
    { radius: 15, x: 700, y: 360 }.circle!(Color::LIGHT_GREY),
    { radius: 100, thickness: 20, x: 1000, y: 360 }.circle!(Color::STEEL_BLUE),
    { radius: 60, thickness: 12, arc_angle: 320, x: 1000, y: 360 }.circle!(Color::STEEL_BLUE),
    { x: 20, y: 200, x2: 300, y2: 300, thickness: 12, cap: :round }.stroke!(Color::WHITE),
    { x: 20, y: 240, x2: 300, y2: 340, thickness: 12, cap: :butt }.stroke!(Color::WHITE),
    { x: 650, y: 690, x2: 1100, y2: 690, thickness: 30, cap: :round }.stroke!(Color::LIGHT_GREY),
  ]

  puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
end

class RenderTargetSprite
  include Serializable
  attr_sprite

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @w = args.fetch(:w, 0)
    @h = args.fetch(:h, 0)

    @path = args.fetch(:path, nil)
    raise ArgumentError, 'RenderTargetSprite must have a path' if @path.nil?

    @r = args.fetch(:r, 255)
    @g = args.fetch(:g, 255)
    @b = args.fetch(:b, 255)
    @a = args.fetch(:a, 255)

    @angle = args.fetch(:angle, 0)
    @angle_anchor_x = args.fetch(:angle_anchor_x, 0.5)
    @angle_anchor_y = args.fetch(:angle_anchor_y, 0.5)

    @flip_horizontally = args.fetch(:flip_horizontally, false)
    @flip_vertically = args.fetch(:flip_vertically, false)

    @blendmode_enum = args.fetch(:blendmode_enum, 1)

    @anchor_x = args.fetch(:anchor_x, 0)
    @anchor_y = args.fetch(:anchor_y, 0)
  end

  def draw_override(ffi)
    ffi.draw_sprite_5(
      @x, @y, @w, @h,
      @path,
      @angle,
      @a, @r, @g, @b,
      0, 0, -1, -1,
      @flip_horizontally, @flip_vertically,
      @angle_anchor_x, @angle_anchor_y,
      nil, nil, nil, nil,
      @blendmode_enum,
      @anchor_x,
      @anchor_y
    )
  end
end

def circle(**args)
  radius = args.fetch(:radius, 10)
  arc_angle = args.fetch(:arc_angle, 360)
  thickness = args.fetch(:thickness, radius)
  path = "circle:#{radius}:#{arc_angle}:#{thickness}"
  rt_args = $state.rt_cache[path]
  return RenderTargetSprite.new(args.merge(rt_args)) if rt_args

  rt = $args.render_target(path)
  rt_args = {
    anchor_x: 0.5,
    anchor_y: 0.5,
    path: path,
    w: rt.w = radius * 2,
    h: rt.h = radius * 2
  }

  theta = 360 / (2 * Math::PI * radius)
  steps = (arc_angle / theta).ceil
  inner_radius = radius - thickness

  rt.primitives << steps.times.map do |i|
    segment_angle = [i * theta, arc_angle].min

    {
      x: radius + radius * segment_angle.cos,
      y: radius + radius * segment_angle.sin,
      x2: radius + inner_radius * segment_angle.cos,
      y2: radius + inner_radius * segment_angle.sin
    }.line!(Color::WHITE)
  end

  $state.rt_cache[path] = rt_args

  RenderTargetSprite.new(args.merge(rt_args))
end

def stroke(**args)
  thickness = args.fetch(:thickness, 1)
  cap = args.fetch(:cap, :butt)

  x = args.fetch(:x, 1)
  y = args.fetch(:y, 1)
  x2 = args.fetch(:x2, 1)
  y2 = args.fetch(:y2, 1)
  l2 = (x2 - x)**2 + (y2 - y)**2
  path = "line:#{l2}:#{cap}:#{thickness}"
  rt_args = $state.rt_cache[path]
  return RenderTargetSprite.new(args.merge(rt_args)) if rt_args

  length = Math.sqrt(l2)
  half_t = thickness / 2
  circle(radius: half_t) # ensure a circle exists for the end-cap

  rt = $args.render_target(path)
  rt_args = {
    x: x + (cap == :round ? half_t : 0),
    y: y - half_t,
    w: rt.w = cap == :round ? length + thickness : length,
    h: rt.h = thickness,
    path: path,
    angle: Math.atan2(y2 - y, x2 - x).to_degrees,
    angle_anchor_x: cap == :round ? half_t / length : 0,
    angle_anchor_y: 0.5
  }

  rt.primitives << case cap
                   when :round then
                    [
                      circle(x: half_t, y: half_t, radius: half_t),
                      { x: half_t, y: 0, w: length, h: thickness }.solid!(Color::WHITE),
                      circle(x: length + half_t, y: half_t, radius: half_t)
                    ]
                   else
                    { x: 0, y: 0, w: length, h: thickness }.solid!(Color::WHITE)
                   end

  $state.rt_cache[path] = rt_args

  RenderTargetSprite.new(args.merge(rt_args))
end

module CachedRenderTargetResetExtension
  def reset(*args)
    super
    $state.rt_cache = {}
  end
end

class Hash
  def circle!(p)
    a = p.is_a?(Hash) ? p : p.as_hash
    circle(merge(a))
  end

  def stroke!(p)
    a = p.is_a?(Hash) ? p : p.as_hash
    stroke(merge(a))
  end
end

GTK::Runtime.prepend CachedRenderTargetResetExtension unless GTK::Runtime.is_a? CachedRenderTargetResetExtension

$gtk.reset
