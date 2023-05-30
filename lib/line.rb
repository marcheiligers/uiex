class Line
  include Serializable
  attr_reader :x, :y, :x2, :y2, :thickness, :color, :cap

  def initialize(**args) # x0, y0, x1, y1, thickness)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @x2 = args.fetch(:x2, 0)
    @y2 = args.fetch(:y2, 0)
    @thickness = args.fetch(:thickness, 1)
    @color = args.fetch(:color, Color::BLACK)
    @cap = args.fetch(:cap, :none)

    @changes = :redraw
  end

  def length
    Math.sqrt((@x2 - @x)**2 + (@y2 - @y)**2)
  end

  def angle
    Math.atan2(@y2 - @y, @x2 - @x).to_degrees
  end

  def x=(val)
    @changes = :position if @changes == :none
    @x = val
  end

  def y=(val)
    @changes = :position if @changes == :none
    @y = val
  end

  def x2=(val)
    @changes = :position if @changes == :none
    @x2 = val
  end

  def y2=(val)
    @changes = :position if @changes == :none
    @y2 = val
  end

  def thickness=(val)
    @changes = :redraw
    @thickness = val
  end

  def color=(val)
    @changes = :redraw
    @color = val
  end

  def cap=(val)
    @changes = :redraw
    @cap = val
  end

  def to_primitives
    rect = {
      x: @x,
      y: @y - @thickness / 2,
      w: length,
      h: @thickness,
      angle: angle,
      angle_anchor_x: 0,
      angle_anchor_y: 0.5,
      path: :pixel
    }.sprite!(@color)

    case @cap
    when :none, :butt
      rect
    when :round
      if @changes == :redraw
        @scap = Disk.new(x: @x, y: @y, radius: @thickness / 2, color: @color)
        @ecap = Disk.new(x: @x2, y: @y2, radius: @thickness / 2, color: @color)
      end

      if @changes == :position
        @scap.x = @x
        @scap.y = @y
        @ecap.x = @x2
        @ecap.y = @y2
      end

      @changes = :none

      [
        rect,
        @scap.to_primitives,
        @ecap.to_primitives
      ]
    end
  end
end
