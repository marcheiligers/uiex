module Draggable
  def initialize(**args)
    super(args)

    @dragging = false
  end

  def handle_inputs
    super

    if (result = $args.inputs.mouse.down) && result.inside_rect?(relative_rect)
      @dragging = true
      @drag_x = result.x - relative_x
      @drag_y = result.y - relative_y
    end

    @dragging = false if $args.inputs.mouse.up

    if @dragging && $args.inputs.mouse.moved
      @x += $args.inputs.mouse.x - relative_x - @drag_x
      @y += $args.inputs.mouse.y - relative_y - @drag_y
    end
  end
end
