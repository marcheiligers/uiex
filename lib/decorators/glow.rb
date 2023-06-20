class LineGlow
  include Easing

  # TODO: Draw the circles onto a RT, repeat X times, maybe sometimes lighten more or less
  # Animate by cycling through these RTs fading one in and one out, giving a pulsating effect
  EASE_DUR = 40
  NUM_LAYERS = 2
  DEF_RANGE = 100

  def initialize(line, range = DEF_RANGE)
    @line = line
    @range = range

    prepare

    @cur_index = 0
    @cur_pos = 0
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

    [
      rt1.sprite!(
        x: @line.x + rt1.offset_x,
        y: @line.y + rt1.offset_y,
        r: 0, g: 255, b: 0, a: 255 - a
      ),
      rt2.sprite!(
        x: @line.x + rt2.offset_x,
        y: @line.y + rt2.offset_y,
        r: 0, g: 255, b: 0, a: a
      ),
      @line.to_primitives
    ]
  end

  def prepare
    @rts = NUM_LAYERS.times.map { |i| prepare_rt(i) }
  end

  def prepare_rt(num)
    rts = prepare_with_easing(num)
    rt = $args.render_target("lineglowrt#{num}")
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
      offset_y: -ox,
      w: rt.w,
      h: rt.h,
      path: "lineglowrt#{num}"
    }
  end

  def prepare_with_easing(num)
    mul = @range - @line.thickness
    steps = 255
    # a_step = 245 / steps
    a = 1
    steps.downto(0).map do |pos|
      # a += a_step
      r = ease_in_10x(pos, steps) * mul + @line.thickness
      c = 0.01 # ease_in_10x(pos, steps) * 0.01
      # puts "c => #{c}"
      prep_rt(r, "lineglow#{num}-#{pos}", a, c)
    end + [prep_rt(@line.thickness / 2 + 2, "lineglow-1", 200, 0.7)]
  end

  def prep_rt(range, path, alpha, chance)
    Disk.new(radius: range).create!

    rt = $args.render_target(path)
    rt.w = @line.length + range * 2
    rt.h = @line.thickness + range * 2

    rt.primitives << @line.length.round.times.map do |x|
      next if rand > chance
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
