BG = [0, 0, 0].freeze

def tick args
  args.outputs.background_color = BG

  if args.tick_count == 0
    args.state.cannon = Cannon.new
    args.state.shapes = [
      stroke(x: 50, y: 600, x2: 200, y2: 600, thickness: 50, r: 255, g: 255, b: 255, cap: :round),
      { x: 50, y: 600, x2: 200, y2: 600, r: 255, g: 0, b: 0 }.line!,
      circle(x: 280, y: 600, radius: 25, r: 255, g: 255, b: 255)
    ]
  end

  args.state.cannon.angle += 1

  args.outputs.primitives << [
    args.state.cannon,
    args.state.shapes,
    { x: 10, y: 700, text: "#{$state.rt_cache.length} render targets, #{args.gtk.current_framerate.round} fps" }.label!(Color::WHITE),
    { x: 10, y: 670, x2: 1270, y2: 670, cap: :round, thickness: 3 }.stroke!(Color::WHITE),
  ]
end

class Cannon < Sprite
  WIDTH = 80
  THICKNESS = 3
  CANNON_LENGTH = 30
  BODY_RADIUS = 25

  def initialize
    @x = 100
    @y = 100
    @w = WIDTH
    @h = WIDTH
    @angle = 320

    @base = round_rect(radius: 10, thickness: 5, x: @x, y: @y, w: WIDTH, h: WIDTH, r: 255, g: 255, b: 255, a: 255, anchor_x: 0.5, anchor_y: 0.5)
    @body = circle(radius: BODY_RADIUS, thickness: THICKNESS, arc_angle: 300, x: @x, y: @y, r: 255, g: 255, b: 255, a: 255)
    @cannon = stroke(thickness: 5, x: @x, y: @y, x2: @x + CANNON_LENGTH, y2: @y, r: 255, g: 255, b: 255, a: 255)
  end

  def draw_override(ffi)
    @base.draw_override(ffi)

    @body.angle = @angle + 30
    @body.draw_override(ffi)

    @cannon.angle = @angle
    @cannon.draw_override(ffi)
  end
end
