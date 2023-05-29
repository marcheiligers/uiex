BG = [0, 0, 0].freeze

def init(args)
  args.state.lines = []
  args.state.points = []
  args.state.current_thickness = 20
  args.state.current_line = nil
end

def inputs(args)
  if args.inputs.mouse.button_left && args.state.current_line.nil?
    args.state.current_line = Line.new(
      x: args.inputs.mouse.x,
      y: args.inputs.mouse.y,
      x2: args.inputs.mouse.x,
      y2: args.inputs.mouse.y,
      thickness: args.state.current_thickness,
      color: Color::WHITE,
      cap: :round
    )
    args.state.lines << args.state.current_line
    args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::GREEN).to_primitives
  end

  if !args.inputs.mouse.button_left && args.state.current_line
    args.state.points << Marker.new(x: args.inputs.mouse.x, y: args.inputs.mouse.y, color: Color::RED).to_primitives
    args.state.current_line = nil
  end

  args.state.current_thickness += 1 if args.inputs.keyboard.key_down.equal_sign
  args.state.current_thickness -= 1 if args.inputs.keyboard.key_down.minus
  args.state.current_thickness = 1 if args.state.current_thickness < 1

  if args.state.current_line
    args.state.current_line.x2 = args.inputs.mouse.x
    args.state.current_line.y2 = args.inputs.mouse.y
    args.state.current_line.thickness = args.state.current_thickness
  end
end

def draw(args)
  args.outputs.primitives << args.state.lines.map(&:to_primitives) << args.state.points

  args.outputs.primitives << Circle.new(x: 600, y: 300, radius: 100, thickness: 4, color: Color::RED).to_primitives
  args.outputs.primitives << Disk.new(x: 600, y: 300, radius: 100, color: Color.new(0, 225, 0, 80)).to_primitives

  args.outputs.primitives << Disk.new(x: 300, y: 300, radius: 100, color: Color.new(0, 225, 0, 80)).to_primitives
  args.outputs.primitives << Circle.new(x: 300, y: 300, radius: 100, thickness: 4, color: Color::RED).to_primitives
end

def tick(args)
  args.outputs.background_color = BG
  init(args) if args.tick_count == 0

  inputs(args)
  draw(args)
  # puts args.state.lines

  $gtk.reset if args.inputs.keyboard.key_down.r
end

$gtk.reset
