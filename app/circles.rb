BG = [0, 0, 0].freeze
ITER = 200 # 640
PER_TICK = 100

# def tick args
#   args.outputs.background_color = BG

#   if args.tick_count == 0
#     args.state.circles = []
#   end

#   if args.tick_count == 10
#     args.state.start_time = Time.now

#     # args.state.circles = ITER.times.map do |i|
#     #   circle(radius: i * 3, x: 50 + i * 6, y: 360, r: i * 2, g: i, b: 255 - i * 2)
#     # end

#     # args.state.circles = ITER.times.map do |i|
#     #   circle(radius: ITER * 3 - i * 3, arc_angle: 75)
#     # end + ITER.idiv(4).times.map do |i|
#     #   circle(radius: ITER * 2 - i * 8, thickness: 2, arc_angle: 265, angle: 85)
#     # end

#     args.state.circles = ITER.times.map do |i|
#       circle(radius: ITER * 2 - i * 2)
#     end

#     args.state.time_spent = Time.now - args.state.start_time
#   end

#   if args.tick_count == 11
#     args.state.frame_time = Time.now - args.state.start_time
#   end

#   i = -1
#   cs = args.state.circles
#   l = cs.length
#   tc = args.tick_count
#   x = args.inputs.mouse.x
#   y = args.inputs.mouse.y
#   while (i += 1) < l
#     c = cs[i]
#     c.x = x
#     c.y = y
#     c.r = (tc + i) % 255
#     c.g = (tc + i + 85) % 255
#     c.b = (tc + i + 170) % 255
#   end

#   args.outputs.primitives << [
#     args.state.circles,
#     { x: 10, y: 700, text: "#{$state.circles.length} circles, #{$state.rt_cache.length} render targets, draw frame took #{$state.frame_time}s (#{$state.time_spent}s), #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
#     { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
#   ]

#   puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
# end

# STRESS TEST
# def tick args
#   args.outputs.background_color = BG

#   if args.tick_count == 0
#     args.state.circles = []
#   end

#   args.state.circles << circle(radius: rand(100) + 100, thickness: rand(100), x: rand(1280), y: rand(720), r: rand(255), g: rand(255), b: rand(255), a: rand(255))

#   args.outputs.primitives << [
#     args.state.circles,
#     { x: 10, y: 700, text: "#{$state.circles.length} circles, #{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
#     { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
#   ]

#   puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
# end

# SHEER STUPITY
# def tick args
#   args.outputs.background_color = BG

#   if args.tick_count == 0
#     args.state.circles = 0
#     base_primitive = { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: 255 }
#     args.state.render_targets = [
#       { render_target: args.render_target('even'), primitive: base_primitive.merge(path: 'even').sprite! },
#       { render_target: args.render_target('odd'), primitive: base_primitive.merge(path: 'odd').sprite! }
#     ]
#     args.state.render_targets.each_with_index do |rt, i|
#       rt.render_target.transient!
#       rt.render_target.w = 1280
#       rt.render_target.h = 720
#     end
#   end

#   current_circles = Array.new(PER_TICK) { circle(radius: rand(100) + 100, thickness: rand(100), x: rand(1280), y: rand(720), r: rand(255), g: rand(255), b: rand(255), a: rand(255)) }
#   # current_circles = Array.new(PER_TICK) { circle(radius: rand(100) + 100, x: rand(1280), y: rand(720), r: rand(255), g: rand(255), b: rand(255), a: rand(255)) }
#   current_index = args.tick_count % 2
#   current_render_target = args.state.render_targets[current_index]
#   prev_render_target = args.state.render_targets[1 - current_index]
#   args.outputs[current_render_target.primitive.path].primitives << [prev_render_target.primitive, current_circles]
#   args.state.circles += PER_TICK

#   args.outputs.primitives << [
#     current_render_target.primitive,
#     { x: 10, y: 700, text: "#{$state.circles} circles, #{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
#     { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
#   ]

#   puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
# end

# RECT STRESS TEST
def tick args
  args.outputs.background_color = BG

  if args.tick_count == 0
    args.state.shapes = []
    # args.state.shapes << { x: 50, y: 50, w: 200, h: 100, r: 0, g: 0, b: 128, a: 128 }.solid!
    # args.state.shapes << round_rect(radius: 20, thickness: 5, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
    # args.state.shapes << ellipse(thickness: 5, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
    # args.state.shapes << reg_poly(sides: 8, thickness: 20, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
    # args.state.shapes << reg_star(sides: 8, thickness: 20, x: 50, y: 50, w: 200, h: 200, r: 255, g: 255, b: 255, a: 255)
  end

  case rand(6)
  when 0
    args.state.shapes << circle(
      radius: rand(100) + 100, thickness: rand(100),
      x: rand(1280), y: rand(720),
      r: rand(255), g: rand(255), b: rand(255), a: rand(255)
    )
  when 1
    args.state.shapes << rect(
      thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 2
    args.state.shapes << round_rect(
      radius: rand(20) + 5, thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 3
    args.state.shapes << ellipse(
      thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 4
    args.state.shapes << reg_poly(
      sides: rand(7) + 5, thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 5
    args.state.shapes << reg_star(
      sides: rand(7) + 5, thickness: rand(100), ratio: rand * 0.5 + 0.25,
      x: rand(1280), y: rand(720), w: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  end

  args.outputs.primitives << [
    args.state.shapes,
    { x: 10, y: 700, text: "#{$state.shapes.length} shapes, #{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
    { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
  ]

  puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
end

class Sprite
  include Serializable
  attr_sprite

  def initialize(**params)
    @x = params[:x] || 0
    @y = params[:y] || 0
    @w = params[:w] || 0
    @h = params[:h] || 0

    @path = params[:path] || :pixel

    @r = params[:r] || 255
    @g = params[:g] || 255
    @b = params[:b] || 255
    @a = params[:a] || 255

    @angle = params[:angle] || 0
    @angle_anchor_x = params[:angle_anchor_x] || 0.5
    @angle_anchor_y = params[:angle_anchor_y] || 0.5

    @flip_horizontally = params[:flip_horizontally] || false
    @flip_vertically = params[:flip_vertically] || false

    @tile_x = params[:tile_x] || nil
    @tile_y = params[:tile_y] || nil
    @tile_w = params[:tile_w] || nil
    @tile_h = params[:tile_h] || nil

    @source_x = params[:source_x] || nil
    @source_y = params[:source_y] || nil
    @source_w = params[:source_w] || nil
    @source_h = params[:source_h] || nil

    @blendmode_enum = params[:blendmode_enum] || 1

    @anchor_x = params[:anchor_x] || 0
    @anchor_y = params[:anchor_y] || 0
  end

  def draw_override(ffi)
    ffi.draw_sprite_5(
      @x, @y, @w, @h,
      @path,
      @angle,
      @a, @r, @g, @b,
      @tile_x, @tile_y, @tile_w, @tile_h,
      @flip_horizontally, @flip_vertically,
      @angle_anchor_x, @angle_anchor_y,
      @source_x, @source_y, @source_w, @source_h,
      @blendmode_enum,
      @anchor_x, @anchor_y
    )
  end
end

class LambdaRenderer
  def initialize(draw_lambda = nil, &draw_block)
    @draw_lambda = draw_lambda || draw_block
  end

  def draw_override(ffi)
    @draw_lambda.call(ffi)
  end

  def primitive_marker
    :sprite
  end
end

module Shapes
  def circle(**params)
    radius = params[:radius] || 10
    arc_angle = params[:arc_angle] || 360
    thickness = params[:thickness] || radius
    path = "circle:#{radius}:#{arc_angle}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    rt = $args.render_target(path)
    rt_params = {
      anchor_x: 0.5,
      anchor_y: 0.5,
      path: path,
      w: rt.w = radius * 2,
      h: rt.h = radius * 2
    }

    theta = 360 / (2 * Math::PI * radius)
    inner_radius = 0.greater(radius - thickness)
    if arc_angle == 360
      steps = (arc_angle / theta / 8.0).ceil + 1 # 1/8 as many steps

      if inner_radius == 0
        rt.primitives << LambdaRenderer.new do |ffi|
          i = -1
          while (i += 1) < steps
            segment_angle = i * theta
            x = radius * segment_angle.cos
            y = radius * segment_angle.sin

            ffi.draw_line(radius + x, radius + y, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius - x, radius + y, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius + x, radius - y, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius - x, radius - y, radius, radius, 255, 255, 255, 255)

            ffi.draw_line(radius + y, radius + x, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius - y, radius + x, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius + y, radius - x, radius, radius, 255, 255, 255, 255)
            ffi.draw_line(radius - y, radius - x, radius, radius, 255, 255, 255, 255)
          end
        end
      else
        rt.primitives << LambdaRenderer.new do |ffi|
          i = -1
          while (i += 1) < steps
            segment_angle = i * theta
            c = segment_angle.cos
            s = segment_angle.sin
            x = radius * c
            y = radius * s
            ix = inner_radius * c
            iy = inner_radius * s

            ffi.draw_line(radius + x, radius + y, radius + ix, radius + iy, 255, 255, 255, 255)
            ffi.draw_line(radius - x, radius + y, radius - ix, radius + iy, 255, 255, 255, 255)
            ffi.draw_line(radius + x, radius - y, radius + ix, radius - iy, 255, 255, 255, 255)
            ffi.draw_line(radius - x, radius - y, radius - ix, radius - iy, 255, 255, 255, 255)

            ffi.draw_line(radius + y, radius + x, radius + iy, radius + ix, 255, 255, 255, 255)
            ffi.draw_line(radius - y, radius + x, radius - iy, radius + ix, 255, 255, 255, 255)
            ffi.draw_line(radius + y, radius - x, radius + iy, radius - ix, 255, 255, 255, 255)
            ffi.draw_line(radius - y, radius - x, radius - iy, radius - ix, 255, 255, 255, 255)
          end
        end
      end
    else
      steps = (arc_angle / theta).ceil

      rt.primitives << LambdaRenderer.new do |ffi|
        i = -1
        while (i += 1) < steps
          segment_angle = arc_angle.lesser(i * theta)
          c = segment_angle.cos
          s = segment_angle.sin

          ffi.draw_line(
            radius + radius * c, radius + radius * s,
            radius + inner_radius * c, radius + inner_radius * s,
            255, 255, 255, 255
          )
        end
      end
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def stroke(**params)
    thickness = params[:thickness] || 1
    cap = params[:cap] || :butt

    x = params[:x] || 1
    y = params[:y] || 1
    x2 = params[:x2] || 1
    y2 = params[:y2] || 1

    l2 = (x2 - x)**2 + (y2 - y)**2
    path = "line:#{l2}:#{cap}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    length = Math.sqrt(l2)
    half_t = thickness / 2.0
    circle(radius: half_t) if cap == :round # ensure a circle exists for the end-cap

    rt = $args.render_target(path)
    rt_params = {
      w: rt.w = cap == :round ? length + thickness : length,
      h: rt.h = thickness,
      path: path,
      angle: Math.atan2(y2 - y, x2 - x).to_degrees,
      angle_anchor_x: cap == :round ? half_t / length : 0,
      angle_anchor_y: 0.5
    }
    # Adjust params for cap and thickness
    params.merge({
      x: x - (cap == :round ? half_t : 0),
      y: y - half_t,
    })

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

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def rect(**params)
    thickness = params[:thickness] || 1
    w = params[:w] || 1
    h = params[:h] || 1


    path = "rect:#{w}:#{h}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    rt = $args.render_target(path)
    rt_params = {
      w: rt.w = w,
      h: rt.h = h,
      path: path
    }

    rt.primitives << LambdaRenderer.new do |ffi|
      ffi.draw_solid(0, 0, w, thickness, 255, 255, 255, 255)
      ffi.draw_solid(0, 0, thickness, h, 255, 255, 255, 255)
      ffi.draw_solid(0, h - thickness, w, thickness, 255, 255, 255, 255)
      ffi.draw_solid(w - thickness, 0, thickness, h, 255, 255, 255, 255)
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def round_rect(**params)
    radius = params[:radius] || 1
    thickness = params[:thickness] || 1
    w = params[:w] || 1
    h = params[:h] || 1

    path = "round_rect:#{w}:#{h}:#{radius}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    cpath = circle(radius: radius, thickness: thickness, arc_angle: 90).path
    rt = $args.render_target(path)
    rt_params = {
      w: rt.w = w,
      h: rt.h = h,
      path: path
    }

    r2 = radius * 2
    rt.primitives << LambdaRenderer.new do |ffi|
      ffi.draw_solid(radius, 0, w - r2, thickness, 255, 255, 255, 255)
      ffi.draw_solid(0, radius, thickness, h - r2, 255, 255, 255, 255)
      ffi.draw_solid(radius, h - thickness, w - r2, thickness, 255, 255, 255, 255)
      ffi.draw_solid(w - thickness, radius, thickness, h - r2, 255, 255, 255, 255)

      ffi.draw_sprite_3(0, 0, r2, r2, cpath, 0, 255, 255, 255, 255, nil, nil, nil, nil, true, true, 0, 0, nil, nil, nil, nil)
      ffi.draw_sprite_3(w - r2, 0, r2, r2, cpath, 0, 255, 255, 255, 255, nil, nil, nil, nil, false, true, 0, 0, nil, nil, nil, nil)
      ffi.draw_sprite_3(0, h - r2, r2, r2, cpath, 0, 255, 255, 255, 255, nil, nil, nil, nil, true, false, 0, 0, nil, nil, nil, nil)
      ffi.draw_sprite_3(w - r2, h - r2, r2, r2, cpath, 0, 255, 255, 255, 255, nil, nil, nil, nil, false, false, 0, 0, nil, nil, nil, nil)
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def ellipse(**params)
    w = params[:w] || 10
    h = params[:h] || 10
    arc_angle = params[:arc_angle] || 360
    thickness = params[:thickness] || w.greater(h)
    path = "ellipse:#{w}:#{h}:#{arc_angle}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    rt = $args.render_target(path)
    rt_params = {
      path: path,
      w: rt.w = w,
      h: rt.h = h
    }

    theta = 360 / (2 * Math::PI * w.greater(h)) # approx
    steps = (arc_angle / theta).ceil
    half_w = w / 2.0
    half_h = h / 2.0
    half_iw = half_w - thickness
    half_ih = half_h - thickness

    rt.primitives << LambdaRenderer.new do |ffi|
      i = -1
      while (i += 1) < steps
        segment_angle = arc_angle.lesser(i * theta)
        c = segment_angle.cos
        s = segment_angle.sin

        ffi.draw_line(
          half_w + half_w * c, half_h + half_h * s,
          half_w + half_iw * c, half_h + half_ih * s,
          255, 255, 255, 255
        )
      end
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def reg_poly(**params)
    sides = params[:sides] || 1
    thickness = params[:thickness] || 1
    w = params[:w] || 1
    h = params[:h] || w

    path = "reg_poly:#{sides}:#{w}:#{h}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    rt = $args.render_target(path)
    rt_params = {
      path: path,
      w: rt.w = w,
      h: rt.h = h
    }

    half_w = w / 2.0
    half_h = h / 2.0
    half_iw = half_w + 1
    half_ih = half_h + 1
    theta = 360.0 / sides

    rt.primitives << LambdaRenderer.new do |ffi|
      t = -1
      while (t += 1) < thickness
        half_iw -= 1
        half_ih -= 1
        i = 0
        x = half_w + half_iw
        y = half_h
        while (i += 1) < sides
          x1 = half_w + half_iw * (i * theta).cos
          y1 = half_h + half_ih * (i * theta).sin
          ffi.draw_line(x, y, x1, y1, 255, 255, 255, 255)
          x = x1
          y = y1
        end
        ffi.draw_line(half_w + half_iw, half_h, x, y, 255, 255, 255, 255)
      end
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end

  def reg_star(**params)
    sides = params[:sides] || 1
    thickness = params[:thickness] || 1
    w = params[:w] || 1
    h = params[:h] || w
    ratio = params[:ratio] || 0.5

    path = "reg_poly:#{sides}:#{w}:#{h}:#{ratio}:#{thickness}"
    rt_params = $state.rt_cache[path]
    return Sprite.new(params.merge(rt_params)) if rt_params

    rt = $args.render_target(path)
    rt_params = {
      path: path,
      w: rt.w = w,
      h: rt.h = h
    }

    half_w = w / 2.0
    half_h = h / 2.0
    half_iw = half_w + 1
    half_ih = half_h + 1
    theta = 360.0 / sides
    half_theta = theta / 2

    rt.primitives << LambdaRenderer.new do |ffi|
      t = -1
      while (t += 1) < thickness
        half_iw -= 1
        half_ih -= 1
        i = 0
        x = half_w + half_iw
        y = half_h
        xi = half_w + half_iw * ratio * half_theta.cos
        yi = half_h + half_ih * ratio * half_theta.sin
        while (i += 1) < sides
          x1 = half_w + half_iw * (i * theta).cos
          y1 = half_h + half_ih * (i * theta).sin
          ffi.draw_line(x, y, xi, yi, 255, 255, 255, 255)
          ffi.draw_line(xi, yi, x1, y1, 255, 255, 255, 255)
          x = x1
          y = y1
          xi = half_w + half_iw * ratio * (i * theta + half_theta).cos
          yi = half_h + half_ih * ratio * (i * theta + half_theta).sin
        end
        ffi.draw_line(x, y, xi, yi, 255, 255, 255, 255)
        ffi.draw_line(half_w + half_iw, half_h, xi, yi, 255, 255, 255, 255)
      end
    end

    $state.rt_cache[path] = rt_params

    Sprite.new(params.merge(rt_params))
  end
end

include Shapes

module CachedRenderTargetResetExtension
  def reset(*args)
    super
    $state.rt_cache = {}
  end
end

class Hash
  include Shapes

  def circle!(params)
    a = params.is_a?(Hash) ? params : params.as_hash
    circle(merge(a))
  end

  def stroke!(params)
    a = params.is_a?(Hash) ? params : params.as_hash
    stroke(merge(a))
  end
end

GTK::Runtime.prepend CachedRenderTargetResetExtension unless GTK::Runtime.is_a? CachedRenderTargetResetExtension

$gtk.reset
