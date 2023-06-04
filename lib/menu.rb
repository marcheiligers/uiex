class Menu < Window
  attr_accessor :padding, :spacing
  attr_reader :focus_rect, :focus_rect_front, :layout

  def initialize(**args)
    super(args)

    @focus_rect = args[:focus_rect]
    @focus_rect_front = args.fetch(:focus_rect_front, true)

    @layout = args.fetch(
      :layout,
      HorizontalLayout.new(
        padding: args.fetch(:padding, 0),
        spacing: args.fetch(:spacing, 0),
        default_w: args.fetch(:default_w, 80)
      )
    )
    @layout.owner = self

    @debounce_input = DebounceInput.new(ARROW_KEYS)
  end

  # Statics cannot be selected or clicked. Think seperators or subtitles.
  def add_static(child)
    layout.add(child)
    child.focussable = false
    children.add(child)
  end

  def add_item(child)
    layout.add(child)
    children.add(child)
    child.attach_observer(self)
  end

  def add_button(text)
    add_item(Button.new(text: text))
  end

  def add_separator
    add_static(HorizontalRule.new)
  end

  def observe(event)
    case event.name
    when :mouse_enter
      event.target.focus
      blur_children(event.target)
      focus_rect&.focus(event.target)
    when :pressed
      puts "#{event.target} pressed"
    end
  end

  def handle_inputs
    return unless visible?

    super

    case @debounce_input.debounce
    when :up, :left
      child = prev_focussable_child
      child.focus
      blur_children(child)
      focus_rect&.focus(child)
    when :down, :right
      child = next_focussable_child
      child.focus
      blur_children(child)
      focus_rect&.focus(child)
    end
  end

  def to_primitives
    if focus_rect_front
      [super] + [focus_rect ? focus_rect.to_primitives : nil]
    else
      [focus_rect ? focus_rect.to_primitives : nil] + [super]
    end
  end

private
  def prev_focussable_child(cur_index = focussed_child_index)
    children[0..(cur_index ? cur_index - 1 : -1)].reverse.detect(&:focussable?) || next_focussable_child(-1)
  end

  def next_focussable_child(cur_index = focussed_child_index)
    children[(cur_index ? cur_index : -1) + 1..-1].detect(&:focussable?) || next_focussable_child(-1)
  end
end
