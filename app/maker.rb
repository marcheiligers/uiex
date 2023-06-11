BG = [0, 0, 0].freeze

def init(args)
  args.state.shapes = [
    # Circle.new(x: 600, y: 300, radius: 100, thickness: 4, color: Color::RED),
    # Disk.new(x: 600, y: 300, radius: 100, color: Color.new(0, 225, 0, 80)),
    # Disk.new(x: 300, y: 300, radius: 100, color: Color.new(0, 225, 0, 80)),
    # Circle.new(x: 300, y: 300, radius: 100, thickness: 4, color: Color::RED)
  ]
  args.state.points = []
  args.state.current_thickness = 20
  args.state.current_shape = nil
  args.state.mode = :line
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
        cap: :round
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
        )
      else
        args.state.current_shape = Circle.new(
          x: args.inputs.mouse.x,
          y: args.inputs.mouse.y,
          radius: 1,
          thickness: args.state.current_thickness,
          color: args.state.color,
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
      args.state.current_shape.radius = Math.sqrt((args.inputs.mouse.x - args.state.current_shape.x)**2 + (args.inputs.mouse.y - args.state.current_shape.y)**2)
    end
  end

  args.state.current_thickness += 1 if args.inputs.keyboard.key_down.equal_sign
  args.state.current_thickness -= 1 if args.inputs.keyboard.key_down.minus
  args.state.current_thickness = 1 if args.state.current_thickness < 1
  args.state.slider.value = args.state.current_thickness

  args.state.menu.handle_inputs
end

def draw(args)
  args.outputs.primitives << args.state.shapes.map(&:to_primitives)
  args.outputs.primitives << args.state.points if args.state.debug
  args.outputs.primitives << args.state.menu.to_primitives
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
