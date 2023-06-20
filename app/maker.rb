BG = [0, 0, 0].freeze

def init(args)
  args.state.base = Circle.new(x: 100, y: 600, radius: 50, thickness: 10, color: Color::WHITE, start_angle: 40)
  args.state.cannon = Line.new(x: 100, y: 600, x2: 170, y2: 600, thickness: 10, color: Color::WHITE, rotate: 20)


  args.state.shapes = [
    args.state.base,
    args.state.cannon,
    # LineSmoke.new(Line.new(x: 300, y: 360, x2: 900, y2: 360, thickness: 20, cap: :round, color: Color::FUCHSIA.lighten_by(4)))
    LineGlow.new(Line.new(x: 320, y: 360, x2: 960, y2: 360, thickness: 20, cap: :round, color: Color::FUCHSIA.lighten_by(4))),
  ]
  args.state.points = []
  args.state.current_thickness = 20
  args.state.current_shape = nil
  args.state.mode = :line
  args.state.cap = :round
  args.state.debug = true
  args.state.color = Color::WHITE

  menu = Menu.new(x: 0, y: 680, w: 1280, h: 40, focus_rect: FocusRect.new)
  mode_group = RadioGroup.new(h: 40)
  mode_group.add_item(Switch.new(text: 'Line', on: true))
  mode_group.add_item(Switch.new(text: 'Circle', on: false))
  mode_group.add_item(Switch.new(text: 'Disk', on: false))
  mode_group.attach_observer(menu) do |event|
    args.state.mode = event.value if event.name == :selected
  end
  menu.add_item(mode_group)

  button = menu.add_button('Clear')
  button.attach_observer(button) do |event|
    if event.name == :pressed
      args.state.shapes = []
      args.state.points = []
    end
  end

  slider = menu.add_item(Slider.new(w: 300, text: 50))
  slider.attach_observer(menu) do |event|
    args.state.current_thickness = slider.value if event.name == :changed
  end

  color_group = RadioGroup.new(h: 40)
  color_group.add_item(Switch.new(text: 'White', on: true))
  color_group.add_item(Switch.new(text: 'Red', on: false))
  color_group.add_item(Switch.new(text: 'Green', on: false))
  color_group.attach_observer(menu) do |event|
    if event.name == :selected
      args.state.color = case event.value
      when :white then Color::WHITE
      when :red then Color::RED
      when :green then Color::GREEN
      end
    end
  end
  menu.add_item(color_group)

  button = menu.add_button('RTs')
  button.attach_observer(button) do |event|
    if event.name == :pressed
      puts "Cached render targets: #{CachedRenderTarget::CACHE.length}"
      puts "Cached render targets paths:\n• #{CachedRenderTarget::CACHE.keys.sort.join("\n• ")}"
    end
  end

  cap_switch = menu.add_item(Switch.new(text: 'Round', on: true))
  cap_switch.attach_observer(menu) do |event|
    if event.name == :pressed
      cap_switch.set(!cap_switch.on?)
      args.state.cap = cap_switch.on? ? :round : :butt
    end
  end

  debug_switch = menu.add_item(Switch.new(text: 'Debug', on: true))
  debug_switch.attach_observer(menu) do |event|
    if event.name == :pressed
      debug_switch.set(!debug_switch.on?)
      args.state.debug = debug_switch.on?
    end
  end

  args.state.menu = menu
  args.state.slider = slider

  putz menu.focussable_children

  args.state.current_index = 0
end

def inputs(args)
  case args.state.mode
  when :line
    if args.inputs.mouse.button_left && args.state.current_shape.nil? && !args.state.menu.contains_point?(args.inputs.mouse.x, args.inputs.mouse.y)
      args.state.current_shape = Line.new(
        x: args.inputs.mouse.x,
        y: args.inputs.mouse.y,
        x2: args.inputs.mouse.x,
        y2: args.inputs.mouse.y,
        thickness: args.state.current_thickness,
        color: args.state.color,
        cap: args.state.cap
      )
      args.state.shapes << args.state.current_shape
      args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::GREEN).to_primitives
    end

    if !args.inputs.mouse.button_left && args.state.current_shape
      args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::RED).to_primitives
      args.state.current_shape = nil
      # args.state.color = args.state.color.lighten_by(60)
      # args.state.color.a = args.state.color.a * 0.6
    end

    if args.state.current_shape
      args.state.current_shape.x2 = args.inputs.mouse.x
      args.state.current_shape.y2 = args.inputs.mouse.y
      args.state.current_shape.thickness = args.state.current_thickness
    end
  when :disk, :circle
    if args.inputs.mouse.button_left && args.state.current_shape.nil? && !args.state.menu.contains_point?(args.inputs.mouse.x, args.inputs.mouse.y)
      if args.state.mode == :disk
        args.state.current_shape = Disk.new(
          x: args.inputs.mouse.x,
          y: args.inputs.mouse.y,
          radius: 1,
          color: args.state.color,
          start_angle: 45,
          end_angle: 135
        )
      else
        args.state.current_shape = Circle.new(
          x: args.inputs.mouse.x,
          y: args.inputs.mouse.y,
          radius: 1,
          thickness: args.state.current_thickness,
          color: args.state.color,
          end_angle: 90
        )
      end
      args.state.shapes << args.state.current_shape
      args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::GREEN).to_primitives
    end

    if !args.inputs.mouse.button_left && args.state.current_shape
      args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::RED).to_primitives
      args.state.current_shape = nil
    end

    if args.state.current_shape
      args.state.current_shape.start_angle = Math.atan2(args.inputs.mouse.y - args.state.current_shape.y, args.inputs.mouse.x - args.state.current_shape.x).to_degrees - 45
      args.state.current_shape.end_angle = args.state.current_shape.start_angle + 90
      args.state.current_shape.radius = Math.sqrt((args.inputs.mouse.x - args.state.current_shape.x)**2 + (args.inputs.mouse.y - args.state.current_shape.y)**2)
    end
  end

  args.state.current_thickness += 1 if args.inputs.keyboard.key_down.equal_sign
  args.state.current_thickness -= 1 if args.inputs.keyboard.key_down.minus
  args.state.current_thickness = 1 if args.state.current_thickness < 1
  args.state.slider.value = args.state.current_thickness

  args.state.menu.handle_inputs

  args.state.current_index -= 1 if args.inputs.keyboard.key_down.z
  args.state.current_index += 1 if args.inputs.keyboard.key_down.x
  args.state.current_index = 0 if args.state.current_index >= CachedRenderTarget::CACHE.length
  args.state.current_index = CachedRenderTarget::CACHE.length - 1 if args.state.current_index < 0

  angle = Math.atan2(args.inputs.mouse.y - args.state.base.y, args.inputs.mouse.x - args.state.base.x).to_degrees
  args.state.base.start_angle = (angle + 20) % 360
  args.state.base.end_angle = (340 - angle) % 360
  args.state.cannon.rotate = angle
end

def draw(args)
  args.outputs.primitives << args.state.shapes.map(&:to_primitives)
  args.outputs.primitives << args.state.points if args.state.debug
  args.outputs.primitives << args.state.menu.to_primitives

  if args.state.current_index < CachedRenderTarget::CACHE.length
    path = CachedRenderTarget::CACHE.keys[args.state.current_index]
    data = CachedRenderTarget::CACHE[path]
    args.outputs.primitives << {
      x: 10,
      y: 30,
      w: data.w,
      h: data.h,
      path: path
    }.sprite!(Color::WHITE)
    args.outputs.primitives << { x: 10, y: 20, text: "#{args.state.current_index}/#{CachedRenderTarget::CACHE.length}: #{path} -> #{data.w}, #{data.h}" }.label!(Color::WHITE)
  end
end

def tick(args)
  args.outputs.background_color = BG
  init(args) if args.tick_count == 0

  inputs(args)
  draw(args)
  # puts args.state.shapes

  $gtk.reset if args.inputs.keyboard.key_down.r
end

$gtk.reset
