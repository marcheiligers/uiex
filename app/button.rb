class Button < Window
  TEXT_ALIGN = { vertical_alignment_enum: 1, alignment_enum: 1 }.freeze

  include Hoverable

  def initialize(**args)
    super(args)

    @text_color = args[:text_color] || Color::BLACK
    @focus_color = args[:focus_color] || Color::WHITE
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
