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

# SHAPES STRESS TEST
# def tick args
#   args.outputs.background_color = BG

#   if args.tick_count == 0
#     args.state.shapes = []
#     # args.state.shapes << { x: 50, y: 50, w: 200, h: 100, r: 0, g: 0, b: 128, a: 128 }.solid!
#     # args.state.shapes << round_rect(radius: 20, thickness: 5, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
#     # args.state.shapes << ellipse(thickness: 5, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
#     # args.state.shapes << reg_poly(sides: 8, thickness: 20, x: 50, y: 50, w: 200, h: 100, r: 255, g: 255, b: 255, a: 255)
#     # args.state.shapes << reg_star(sides: 8, thickness: 20, x: 50, y: 50, w: 200, h: 200, r: 255, g: 255, b: 255, a: 255)
#   end

#   case rand(6)
#   when 0
#     args.state.shapes << circle(
#       radius: rand(100) + 100, thickness: rand(100),
#       x: rand(1280), y: rand(720),
#       r: rand(255), g: rand(255), b: rand(255), a: rand(255)
#     )
#   when 1
#     args.state.shapes << rect(
#       thickness: rand(100),
#       x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
#       r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
#       angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
#       anchor_x: 0.5, anchor_y: 0.5
#     )
#   when 2
#     args.state.shapes << round_rect(
#       radius: rand(20) + 5, thickness: rand(100),
#       x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
#       r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
#       angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
#       anchor_x: 0.5, anchor_y: 0.5
#     )
#   when 3
#     args.state.shapes << ellipse(
#       thickness: rand(100),
#       x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
#       r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
#       angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
#       anchor_x: 0.5, anchor_y: 0.5
#     )
#   when 4
#     args.state.shapes << reg_poly(
#       sides: rand(7) + 5, thickness: rand(100),
#       x: rand(1280), y: rand(720), w: rand(400) + 100,
#       r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
#       angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
#       anchor_x: 0.5, anchor_y: 0.5
#     )
#   when 5
#     args.state.shapes << reg_star(
#       sides: rand(7) + 5, thickness: rand(100), ratio: rand * 0.5 + 0.25,
#       x: rand(1280), y: rand(720), w: rand(400) + 100,
#       r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
#       angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
#       anchor_x: 0.5, anchor_y: 0.5
#     )
#   end

#   args.outputs.primitives << [
#     args.state.shapes,
#     { x: 10, y: 700, text: "#{$state.shapes.length} shapes, #{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
#     { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
#   ]

#   puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
# end

# SHEER INSANITY 2!
def tick args
  args.outputs.background_color = BG

  if args.tick_count == 0
    args.state.shapes = 0
    args.state.sprite = AdditiveSprite.new
  end

  case rand(6)
  when 0
    args.state.sprite.primitives << circle(
      radius: rand(100) + 100, thickness: rand(100),
      x: rand(1280), y: rand(720),
      r: rand(255), g: rand(255), b: rand(255), a: rand(255)
    )
  when 1
    args.state.sprite.primitives << rect(
      thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 2
    args.state.sprite.primitives << round_rect(
      radius: rand(20) + 5, thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 3
    args.state.sprite.primitives << ellipse(
      thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100, h: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 4
    args.state.sprite.primitives << reg_poly(
      sides: rand(7) + 5, thickness: rand(100),
      x: rand(1280), y: rand(720), w: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  when 5
    args.state.sprite.primitives << reg_star(
      sides: rand(7) + 5, thickness: rand(100), ratio: rand * 0.5 + 0.25,
      x: rand(1280), y: rand(720), w: rand(400) + 100,
      r: rand(255), g: rand(255), b: rand(255), a: rand(200) + 55,
      angle_anchor_x: 0.5, angle_anchor_y: 0.5, angle: rand(360),
      anchor_x: 0.5, anchor_y: 0.5
    )
  end
  $state.shapes += 1

  args.outputs.primitives << [
    args.state.sprite.sprite!,
    { x: 10, y: 700, text: "#{$state.shapes} shapes, #{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
    { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
  ]

  puts "$state.rt_cache #{$state.rt_cache.keys.join(', ')}" if args.inputs.keyboard.key_down.z
end
