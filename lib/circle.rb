class Circle
  include Serializable
  attr_reader :id
  attr_accessor :x, :y, :radius, :thickness, :color
  CIRCLE_DETAIL = 60

  @@id = 0

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @radius = args.fetch(:radius, 10)
    @thickness = args.fetch(:thickness, 1)
    @color = args.fetch(:color, Color::BLACK)

    @changed = true
    @id = "circle:#{@@id += 1}"
  end

  def to_primitives
    # TODO: Calc detail from radius
    # TODO: Draw regular polygons using the same
    create_render_target if @changed

    {
      x: @x - @radius,
      y: @y - @radius,
      w: size,
      h: size,
      path: @id
    }.sprite!
  end

private

  def size
    @radius * 2 + @thickness
  end

  def create_render_target
    @render_target = $args.render_target(@id)
    @render_target.w = @render_target.h = size

    segment_angle = 360 / CIRCLE_DETAIL
    offset = @radius - @thickness / 2
    primitives = CIRCLE_DETAIL.times.map do |i|
      Line.new(
        x: @radius + offset * (i * segment_angle).cos,
        y: @radius + offset * (i * segment_angle).sin,
        x2: @radius + offset * ((i + 1) * segment_angle).cos,
        y2: @radius + offset * ((i + 1) * segment_angle).sin,
        thickness: @thickness,
        color: @color
      ).to_primitives
    end

    @render_target.primitives << primitives
    @changed = false
  end
end

class Disk
  include Serializable
  attr_accessor :x, :y, :radius, :color, :id
  CIRCLE_DETAIL = 60

  @@id = 0

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @radius = args.fetch(:radius, 10)
    @color = args.fetch(:color, Color::BLACK)

    @changed = true
    @id = "disk:#{@@id += 1}"
  end

  def to_primitives
    create_render_target if @changed

    {
      x: @x - @radius,
      y: @y - @radius,
      w: size,
      h: size,
      path: @id
    }.sprite!
  end

private
  def size
    @radius * 2
  end

  def create_render_target
    @render_target = $args.render_target(@id)
    @render_target.w = @render_target.h = size

    segment_angle = 360 / CIRCLE_DETAIL
    primitives = CIRCLE_DETAIL.times.map do |i|
      {
        x: @radius + @radius * (i * segment_angle).cos,
        y: @radius + @radius * (i * segment_angle).sin,
        x2: @radius + @radius * ((i + 1) * segment_angle).cos,
        y2: @radius + @radius * ((i + 1) * segment_angle).sin,
        x3: @radius,
        y3: @radius
      }.solid!(@color)
    end

    @render_target.primitives << primitives
    @changed = false
  end
end
