class Color
  attr_accessor :r, :g, :b

  def initialize(r, g, b)
    @r = r
    @g = g
    @b = b
  end

  def to_h
    { r: @r, g: @g, b: @b }
  end

  WHITE = Color.new(255, 255, 255)
  LIGHT_GREY = Color.new(240, 240, 240)
  GREY = Color.new(128, 128, 128)
  BLACK = Color.new(0, 0, 0)
end
