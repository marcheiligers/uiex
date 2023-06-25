class LineGlow
  include Easing

  # TODO: Draw the circles onto a RT, repeat X times, maybe sometimes lighten more or less
  # Animate by cycling through these RTs fading one in and one out, giving a pulsating effect
  EASE_DUR = 40
  NUM_LAYERS = 2
  DEF_RANGE = 200

  def initialize(line, range = DEF_RANGE)
    @line = line
    @range = range

    prepare

    @cur_index = 0
    @cur_pos = 0

    @color = @line.color
    @line.color = @color.lighten_by(5)
  end

  def to_primitives
    rt1 = @rts[@cur_index]
    rt2 = @rts[(@cur_index + 1) % @rts.length]
    a = ease_in_linear(@cur_pos += 1, EASE_DUR) * 255
    if @cur_pos == EASE_DUR
      @cur_pos = 0
      @cur_index += 1
      @cur_index = 0 if @cur_index >= @rts.length
    end

    col = @color.as_rgb_hash

    [
      rt1.sprite!(
        x: @line.x + rt1.offset_x,
        y: @line.y + rt1.offset_y,
        a: 255 - a,
        **col
      ),
      rt2.sprite!(
        x: @line.x + rt2.offset_x,
        y: @line.y + rt2.offset_y,
        a: a,
        **col
      ),
      @line.to_primitives
    ]
  end

  def prepare
    @rts = NUM_LAYERS.times.map { |i| prepare_rt(i) }
  end

  def prepare_rt(num)
    rts = prepare_with_easing(num)
    rt = $args.render_target("lineglowrt#{num}") #TODO: thing
    rt.w = rts[0].w
    rt.h = rts[0].h
    ox = -rts[0].offset_x
    oy = -rts[0].offset_y
    rt.primitives << rts.map do |r|
      r.sprite!(
        x: ox + r.offset_x,
        y: oy + r.offset_y
      )
    end

    {
      offset_x: -ox,
      offset_y: -oy,
      w: rt.w,
      h: rt.h,
      path: "lineglowrt#{num}"
    }
  end

  def prepare_with_easing(num)
    mul = @range - @line.thickness
    steps = 255
    a = 1
    steps.downto(0).map do |pos|
      r = ease_in_quint(pos, steps) * mul + @line.thickness
      c = 0.01 # ease_in_10x(pos, steps) * 0.01
      prep_rt(r, "lineglow#{num}-#{pos}", a, c)
    end + [prep_rt(@line.thickness / 2 + 2, "lineglow-1", 200, 0.7)]
  end

  def prep_rt(range, path, alpha, chance)
    Disk.new(radius: range).create!

    rt = $args.render_target(path)
    rt.w = @line.length + range * 2
    rt.h = @line.thickness + range * 2

    l = @line.length.round

    rt.primitives << l.times.map do |x|
      next if rand > ease_in_out_parabolic(x, l) * chance * 2 + chance
      Disk.new(x: range + x, y: range, radius: range, color: Color::WHITE).to_primitives
    end

    {
      w: rt.w,
      h: rt.h,
      offset_x: -range,
      offset_y: -range,
      path: path,
      a: alpha
    }
  end
end

def linear_track(length)
  i = -1
  -> { i += 1; i < length ? { x: i, y: 0 } : nil }
end

def circular_track(radius, start_angle: 0, end_angle: 360)
  theta = 360 / (2 * Math::PI * @radius)
  angular_dist = (end_angle - start_angle).abs
  steps = (angular_dist / theta).ceil
  i = -1
  -> { i += 1; i < steps ? { x: (i * theta + start_angle).cos, y: (i * theta + start_angle).sin } : nil }
end

def glow_along_track(track)
end

def alpha_glow_along_track(range, path, alpha, chance)
end
