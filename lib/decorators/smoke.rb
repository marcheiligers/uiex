# TODO: This is very hardcoded atm
class LineSmoke
  def initialize(line)
    @line = line

    prepare
  end

  def to_primitives
    shift
    @primitives.map { |p| p.to_primitives }
  end

  def prepare
    # TODO: calculate how many circles are needed by length
    # This might require transient RTs
    color1 = Color::FUCHSIA.lighten_by(25).with_a(2)
    color2 = Color::FUCHSIA.lighten_by(75).with_a(3)
    @smoke =
      Array.new(100) { Disk.new(x: 250 + rand(700), y: 250 + rand(100), radius: 100, color: color1) } +
      Array.new(100) { Disk.new(x: 280 + rand(640), y: 280 + rand(40), radius: 40, color: color1) } +
      Array.new(300) { Disk.new(x: 285 + rand(640), y: 285 + rand(30), radius: 20, color: color2) }

    @outer_line = Line.new(x: 300, y: 300, x2: 900, y2: 300, thickness: 20, cap: :round, color: Color::FUCHSIA.with_a(80)) # original line color
    @inner_line = Line.new(x: 301, y: 300, x2: 899, y2: 300, thickness: 18, cap: :round, color: Color::FUCHSIA.lighten_by(4))

    @primitives = @smoke + [@outer_line, @inner_line]
  end

  def shift
    # TODO: while loop
    @smoke.each do |c|
      next if rand > 0.2
      c.x += (rand - 0.5) * 3
      c.y += (rand - 0.5) * 3
    end
  end
end
