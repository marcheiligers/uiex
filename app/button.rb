class Button < Window
  TEXT_ALIGN = { vertical_alignment_enum: 1, alignment_enum: 1 }

  def initialize(**args)
    super(args)

    @text_color = args[:text_color] || Color::BLACK
    @focus_color = args[:text_color] || Color::WHITE
  end

  def handle_inputs
    if $args.inputs.mouse.inside_rect?(relative_rect)
      if !@pointer_inside
        notify_observers(Event.new(:pointer_enter, self))
        @pointer_inside = true
      end
    else
      if @pointer_inside
        notify_observers(Event.new(:pointer_leave, self))
        @pointer_inside = false
      end
    end

    if focussed? && (result = input_accepted?)
      if result.is_a?(GTK::MousePoint)
        notify_observers(Event.new(:pressed, self)) if result.inside_rect?(relative_rect)
      else
        notify_observers(Event.new(:pressed, self))
      end
    end
  end

  def to_primitives
    background_color = focussed? ? @focus_color : @color.to_h

    [
      relative_rect.solid!(**background_color.to_h),
      relative_center.label!(TEXT_ALIGN.merge(text: text, **@text_color.to_h))
    ]
  end
end

class DraggableButton < Button
  include Draggable
end

