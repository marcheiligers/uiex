class Marker
  include Serializable
  attr_accessor :x, :y, :offset, :color

  def initialize(**args)
    @x = args.fetch(:x, 0)
    @y = args.fetch(:y, 0)
    @offset = args.fetch(:offset, 3)
    @color = args.fetch(:color, Color::BLACK)
  end

  def to_primitives
    [
      { x: @x - @offset, y: @y - @offset, x2: @x + @offset, y2: @y + @offset }.line!(@color),
      { x: @x - @offset, y: @y + @offset, x2: @x + @offset, y2: @y - @offset }.line!(@color)
    ]
  end
end
