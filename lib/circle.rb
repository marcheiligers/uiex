# TODO: Why shouldn't this be a window?
class Circle
  include Serializable
  include CachedRenderTarget

  attr_reader :id
  attr_accessor :x, :y, :radius, :thickness, :color, :start_angle, :end_angle
  CIRCLE_DETAIL = 60

  # TODO: add start_angle, end_angle, angle
  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @radius = args.fetch(:radius, 10)
    @thickness = args.fetch(:thickness, 1)
    @color = args.fetch(:color, Color::BLACK)
    @start_angle = args.fetch(:start_angle, 0)
    @end_angle = args.fetch(:end_angle, 360)
  end

  def to_primitives
    # TODO: Calc detail from radius
    # TODO: Draw regular polygons using the same
    path = "circle:#{accuracy_cache_key(@radius)}:#{@thickness}:#{angular_dist}"
    cached_rt(path) { |rt| create_render_target(rt) }

    {
      x: @x - @radius,
      y: @y - @radius,
      w: size,
      h: size,
      path: path
      # TODO: angles
    }.sprite!(@color)
  end

  # TODO: add rect methods

private

  def angular_dist
    @angular_dist ||= (@end_angle - @start_angle).abs
  end

  def size
    @radius * 2 + @thickness
  end

  def create_render_target(rt)
    rt.w = rt.h = size

    offset = @radius - @thickness / 2
    circle_detail = (angular_dist.fdiv(360) * CIRCLE_DETAIL).ceil
    segment_angle = angular_dist / circle_detail
    primitives = circle_detail.times.map do |i|
      segment_start_angle = @start_angle + i * segment_angle
      segment_end_angle = [segment_start_angle + segment_angle, @end_angle].min
      Line.new(
        x: @radius + offset * segment_start_angle.cos,
        y: @radius + offset * segment_start_angle.sin,
        x2: @radius + offset * segment_end_angle.cos,
        y2: @radius + offset * segment_end_angle.sin,
        thickness: @thickness,
        color: Color::WHITE,
        cap: :round
      ).to_primitives
    end

    rt.primitives << primitives
  end
end

class Disk
  include Serializable
  include CachedRenderTarget

  attr_accessor :x, :y, :radius, :color, :id, :start_angle, :end_angle
  CIRCLE_DETAIL = 60

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @radius = args.fetch(:radius, 10)
    @color = args.fetch(:color, Color::BLACK)
    @start_angle = args.fetch(:start_angle, 0)
    @end_angle = args.fetch(:end_angle, 360)
  end

  def to_primitives
    path = "disk:#{accuracy_cache_key(@radius)}:#{angular_dist}"
    cached_rt(path) { |rt| create_render_target(rt) }

    {
      x: @x - @radius,
      y: @y - @radius,
      w: size,
      h: size,
      path: path
      # angles
    }.sprite!(@color)
  end

  # TODO: start_angle and end_angle setters ensuring end_angle > start_angle

private
  def angular_dist
    @angular_dist ||= (@end_angle - @start_angle).abs
  end

  def size
    @radius * 2
  end

  def create_render_target(rt)
    rt.w = rt.h = size + 1

    circle_detail = (angular_dist.fdiv(360) * CIRCLE_DETAIL).to_i
    segment_angle = angular_dist / circle_detail
    primitives = circle_detail.times.map do |i|
      segment_start_angle = @start_angle + i * segment_angle
      segment_end_angle = [segment_start_angle + segment_angle, @end_angle].min
      {
        x: @radius + @radius * segment_start_angle.cos,
        y: @radius + @radius * segment_start_angle.sin,
        x2: @radius + @radius * segment_end_angle.cos,
        y2: @radius + @radius * segment_end_angle.sin,
        x3: @radius,
        y3: @radius
      }.solid!(Color::WHITE)
    end

    rt.primitives << primitives
  end
end
