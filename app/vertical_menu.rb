class VerticalMenu < Window
  attr_accessor :padding, :spacing

  def initialize(**args)
    super(args)

    @padding = args[:padding] || 0
    @spacing = args[:spacing] || 0

    @debounce_input = DebounceInput.new(UP_DOWN_ARROW_KEYS) # TODO: UP_DOWN_ARROW_KEYS_AND_WS
  end

  # Statics cannot be selected or clicked. Think seperators or subtitles.
  def add_static(child)
    child.y = calc_top - child.h
    children.add(child)
  end

  def add_selectable(child)
    add_static(child)
    child.attach_observer(self)
  end

  def add_button(text)
    add_selectable(Button.new(x: padding, w: self.w - 2 * padding, h: 40, text: text))
  end

  def add_separator
    add_static(HorizontalRule.new(x: padding, w: self.w - 2 * padding))
  end

  def observe(event)
    case event.name
    when :mouse_enter
      event.target.focus
      blur_children(event.target)
    when :pressed
      puts "#{event.target} pressed"
    end
  end

  def handle_inputs
    return unless visible?

    children.each(&:handle_inputs)

    case @debounce_input.debounce
    when :up
      index = focussed_child_index
      index = if index.nil?
                children.length - 1
              else
                index > 0 ? index - 1 : children.length - 1
              end
      children[index].focus
      blur_children(children[index])
    when :down
      index = focussed_child_index
      index = if index.nil?
                0
              else
                index < children.length - 1 ? index + 1 : 0
              end
      children[index].focus
      blur_children(children[index])
    end
  end

private
  def calc_top
    self.h - (children.inject(0) { |total, child| total + child.h } + spacing * children.length + padding)
  end
end
