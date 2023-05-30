class Dialog < Window
  TEXT_ALIGN = { vertical_alignment_enum: 1, alignment_enum: 1 }.freeze

  def initialize(**args)
    super(args)

    @padding = args.fetch(:padding, 0)
    @spacing = args.fetch(:spacing, 0)
    @focus_rect = args[:focus_rect]
    @focus_rect_front = args.fetch(:focus_rect_front, true)
    @default_height = args.fetch(:default_height, DEFAULT_HEIGHT)

    @debounce_input = DebounceInput.new(UP_DOWN_ARROW_KEYS) # TODO: UP_DOWN_ARROW_KEYS_AND_WS
  end

  def to_primitives
    [super] + title_bar
  end

  def title_bar
    relative_rect = child.relative_rect
    text_size = $gtk.calcstringbox text

    [
      relative_rect.solid!(**background_color.to_h),
      relative_center.label!(TEXT_ALIGN.merge(text: text, **text_color.to_h))
    ]

    if w.to_i > 0
      relative_rect[:x] = child.x - (w - child.w) / 2
      relative_rect[:w] = w
    end

    if h.to_i > 0
      relative_rect[:y] = child.y - (h - child.h) / 2
      relative_rect[:h] = h
    end

    relative_rect.sprite!(path: path)

  end
end
