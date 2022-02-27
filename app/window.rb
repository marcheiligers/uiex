class Window
  include InputEvents
  include Observable
  include Focusable

  attr_accessor :x, :y, :w, :h, :color, :text
  attr_reader :id, :parent, :children

  WINDOW_ARGS = %i[x y w h color text visible]

  @@window_id = 0

  def initialize(**args)
    @id = @@window_id
    @x = args[:x] || 0
    @y = args[:y] || 0
    @w = args[:w] || 0
    @h = args[:h] || 0
    @color = args[:color] || Color::LIGHT_GREY
    @text = args[:text] || "#{self.class.name}#{@@window_id += 1}"
    @visible = args[:visible].nil? || true

    @children = WindowCollection.new(self)
  end

  def parent=(new_parent)
    raise ArgumentError, "Cannot change parent of #{inspect} to #{new_parent.inspect} after it's been set" unless @parent.nil?

    @parent = new_parent
  end

  # Inputs
  def handle_inputs
    children.handle_inputs
  end

  # Visibility TODO: events
  def visible?
    @visible
  end

  def show
    @visible = true
  end

  def hide
    @visible = false
  end

  def relative_x
    @x + @parent&.relative_x.to_i
  end

  def relative_y
    @y + @parent&.relative_y.to_i
  end

  def center
    { x: @x + @w / 2, y: @y + @h / 2 }
  end

  def relative_center
    { x: relative_x + @w / 2, y: relative_y + @h / 2 }
  end

  def to_primitives
    # return unless visible?

    [relative_rect.solid!(color.to_h)] + @children.to_primitives
  end

  def rect
    { x: @x, y: @y, w: @w, h: @h }
  end

  def relative_rect
    { x: relative_x, y: relative_y, w: @w, h: @h }
  end

  def inspect
    "#<#{self.class.name} #{text}>"
  end
end

class WindowCollection
  extend Forwardable

  def_delegators :@collection, :each, :map, :length, :index, :[], :inject

  def initialize(owner = nil)
    @owner = owner
    @collection = []
  end

  def add(child)
    @collection.push(child)
    child.parent = @owner if @owner
    child
  end

  def handle_inputs
    each(&:handle_inputs)
  end

  def to_primitives
    map(&:to_primitives)
  end
end
