class FocusRect < Window
  attr_reader :child

  def initialize(**args)
    @child = args[:child]

    args[:color] ||= Color::STEEL_BLUE
    args[:focussable] ||= false
    args[:visible] ||= !!@child

    super(args)
  end

  def focus_on(child)
    @child = child
    @child ? show : hide
  end

  def to_primitives
    return nil unless child

    rect = child.relative_rect

    [
      rect.merge(h: 2).solid!(color.to_h), # bottom
      rect.merge(y: rect.y + rect.h - 2, h: 2).solid!(color.to_h), # top
      rect.merge(w: 2).solid!(color.to_h), # left
      rect.merge(x: rect.x + rect.w - 2, w: 2).solid!(color.to_h) # right
    ]
  end
end
