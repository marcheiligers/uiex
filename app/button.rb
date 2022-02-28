class Button < Window
  TEXT_ALIGN = { vertical_alignment_enum: 1, alignment_enum: 1 }.freeze

  include Hoverable

  def initialize(**args)
    super(args)

    @text_color = args[:text_color] || Color::BLACK
    @focus_color = args[:focus_color] || Color::WHITE

    # TODO: add callback
  end

  def handle_inputs
    super

    notify_observers(Event.new(:pressed, self)) if focussed? && input_accepted?(relative_rect)
  end

  def to_primitives
    background_color = focussed? ? @focus_color : @color

    [
      relative_rect.solid!(**background_color.to_h),
      relative_center.label!(TEXT_ALIGN.merge(text: text, **@text_color.to_h))
    ]
  end
end

class DraggableButton < Button
  include Draggable
end

class GraphicalButton < Button
  attr_reader :path

  def initialize(**args)
    super(args)

    @path = args[:path]
  end

  def to_primitives
    relative_rect.sprite(path: path)
  end
end

class Switch < Button
  attr_reader :path

  def initialize(**args)
    super(args)

    @on = args.fetch(:on, true)
    @on_color = args.fetch(:on_color, Color::STEEL_BLUE)
    @text_color = args.fetch(:text_color, Color::DARK_GREY)
  end

  def set(on)
    @on = on
  end

  def on?
    @on
  end

  def to_primitives
    background_color = focussed? ? @focus_color : @color
    text_color = on? ? @on_color : @text_color

    [
      relative_rect.solid!(**background_color.to_h),
      relative_center.label!(TEXT_ALIGN.merge(text: text, **text_color.to_h))
    ]
  end
end
