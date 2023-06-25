# TODO: Why shouldn't this be a window?
class Circle
  include Serializable
  include CachedRenderTarget

  attr_reader :id, :radius, :thickness, :start_angle, :end_angle
  attr_accessor :x, :y, :color

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

  def radius=(val)
    reset_rt if val != @radius
    @radius = val
  end

  def thickness=(val)
    reset_rt if val != @thickness
    @thickness = val
  end

  def start_angle=(val)
    @start_angle = val % 360
  end

  def end_angle=(val)
    @end_angle = val % 360
  end

  def to_primitives
    # TODO: Draw regular polygons using the same
    @path ||= "circle:#{accuracy_cache_key(@radius)}:#{@thickness}:#{angular_dist}"
    cached_rt(@path) { |rt| create_render_target(rt) }

    {
      x: @x - @radius,
      y: @y - @radius,
      w: @radius * 2 + 1,
      h: @radius * 2 + 1,
      path: @path,
      angle: @start_angle,
      angle_anchor_x: 0.5,
      angle_anchor_y: 0.5
    }.sprite!(@color)
  end

  # TODO: add rect methods

private
  def reset_rt
    @path = nil
    @size = nil
  end

  def angular_dist
    @angular_dist ||= (@end_angle - @start_angle).abs
  end

  def size
    @size ||= @radius * 2 + @thickness
  end

  # arc length:
  # l = 2πr(ø/360)
  # 360l = 2πrø
  # ø = 360l/2πr

  def create_render_target(rt)
    if @radius < @thickness
      rt.w = rt.h = @radius * 2
      rt.primitives << Disk.primitives(@radius, angular_dist)
    else
      rt.w = rt.h = @radius * 2

      inner_radius = @radius - @thickness
      theta = 360 / (2 * Math::PI * @radius)
      steps = (angular_dist / theta).ceil

      primitives = steps.times.map do |i|
        segment_start_angle = i * theta
        segment_end_angle = [segment_start_angle + theta, angular_dist].min
        [
          { # Two outer points and one inner point
            x: @radius + @radius * segment_start_angle.cos,
            y: @radius + @radius * segment_start_angle.sin,
            x2: @radius + @radius * segment_end_angle.cos,
            y2: @radius + @radius * segment_end_angle.sin,
            x3: @radius + inner_radius * segment_start_angle.cos,
            y3: @radius + inner_radius * segment_start_angle.sin,
          }.solid!(Color::WHITE),
          { # One outer point and two inner points
            x: @radius + inner_radius * segment_end_angle.cos,
            y: @radius + inner_radius * segment_end_angle.sin,
            x2: @radius + @radius * segment_end_angle.cos,
            y2: @radius + @radius * segment_end_angle.sin,
            x3: @radius + inner_radius * segment_start_angle.cos,
            y3: @radius + inner_radius * segment_start_angle.sin,
          }.solid!(Color::WHITE)
        ]
      end

      rt.primitives << primitives
    end
  end
end

class Disk
  include Serializable
  include CachedRenderTarget

  attr_accessor :x, :y, :color, :id, :start_angle, :end_angle
  attr_reader :radius
  CIRCLE_DETAIL = 60

  # TODO: reset @path if properties change
  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @radius = args.fetch(:radius, 10)
    @color = args.fetch(:color, Color::BLACK)
    @start_angle = args.fetch(:start_angle, 0)
    @end_angle = args.fetch(:end_angle, 360)
  end

  def create!
    # This method allows lines to pre-create the round caps
    @path ||= "disk:#{accuracy_cache_key(@radius)}:#{angular_dist}"
    cached_rt(@path) { |rt| create_render_target(rt) }
  end

  def radius=(val)
    reset_rt if val != @radius
    @radius = val
  end

  def to_primitives
    create!

    {
      x: @x - @radius,
      y: @y - @radius,
      w: size,
      h: size,
      path: @path,
      angle: start_angle,
      angle_anchor_x: 0.5,
      angle_anchor_y: 0.5
    }.sprite!(@color)
  end

  def self.prepare_rt(radius, angular_dist = 360)
    # TODO
  end

  def self.primitives(radius, angular_dist = 360)
    # return [] if radius == 0

    # theta = 360 / (2 * Math::PI * radius)
    # steps = [(angular_dist / theta).ceil, 0].max

    # steps.times.map do |i|
    #   segment_start_angle = i * theta
    #   segment_end_angle = [segment_start_angle + theta, angular_dist].min
    circle_detail = (angular_dist.fdiv(360) * CIRCLE_DETAIL).to_i
    segment_angle = angular_dist / circle_detail
    circle_detail.times.map do |i|
      segment_start_angle = i * segment_angle
      segment_end_angle = [segment_start_angle + segment_angle, angular_dist].min
      {
        x: radius + radius * segment_start_angle.cos,
        y: radius + radius * segment_start_angle.sin,
        x2: radius + radius * segment_end_angle.cos,
        y2: radius + radius * segment_end_angle.sin,
        x3: radius,
        y3: radius
      }.solid!(Color::WHITE)
    end
  end

  # TODO: start_angle and end_angle setters ensuring end_angle > start_angle

private

  def reset_rt
    @path = nil
    @angular_dist = nil
    @size = nil
  end

  def angular_dist
    @angular_dist ||= (@end_angle - @start_angle).abs
  end

  def size
    @size ||= @radius * 2
  end

  def create_render_target(rt)
    rt.w = rt.h = size + 1
    rt.primitives << Disk.primitives(@radius, angular_dist)
  end
end
