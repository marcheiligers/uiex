# https://html-color.codes/blue
# Some methods from https://github.com/halostatue/color, under MIT

class Color
  include Serializable

  attr_accessor :r, :g, :b, :a

  def initialize(r, g, b, a = 255)
    @r = r
    @g = g
    @b = b
    @a = a
  end

  def as_hash
    { r: @r, g: @g, b: @b, a: @a }
  end

  def as_rgb_hash
    { r: @r, g: @g, b: @b }
  end

  def to_h
    as_hash
  end

  def to_s
    as_hash.values.join('-')
  end

  def to_a
    [@r, @g, @b, @a]
  end

  def dup
    Color.new(@r, @g, @b, @a)
  end

  # Mix the RGB hue with White so that the RGB hue is the specified
  # percentage of the resulting colour. Strictly speaking, this isn't a
  # darken_by operation.
  def lighten_by(percent)
    mix_with(WHITE, percent)
  end

  # Mix the RGB hue with Black so that the RGB hue is the specified
  # percentage of the resulting colour. Strictly speaking, this isn't a
  # darken_by operation.
  def darken_by(percent)
    mix_with(BLACK, percent)
  end

  # Mix the mask colour (which must be an RGB object) with the current
  # colour at the stated opacity percentage (0..100).
  def mix_with(mask, opacity)
    opacity /= 100.0
    Color.new(
      (@r * opacity) + (mask.r * (1 - opacity)),
      (@g * opacity) + (mask.g * (1 - opacity)),
      (@b * opacity) + (mask.b * (1 - opacity)),
      @a
    )
  end

  def with_a(a)
    rgb = self.dup
    rgb.a = a
    rgb
  end

  WHITE = Color.new(255, 255, 255)
  LIGHT_GREY = Color.new(240, 240, 240)
  GREY = Color.new(128, 128, 128)
  DARK_GREY = Color.new(32, 32, 32)
  BLACK = Color.new(0, 0, 0)
  RED = Color.new(128, 0, 0)
  GREEN = Color.new(0, 255, 0)
  STEEL_BLUE = Color.new(70, 130, 180)
  BLUE = Color.new(0, 0, 255)
  FUCHSIA = Color.new(255, 0, 255)

  TRANSPARENT = Color.new(0, 0, 0, 0)
end
