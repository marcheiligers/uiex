class Window
  include InputEvents
  include Observable

  attr_accessor :x, :y, :w, :h, :r, :g, :b, :text
  attr_reader :parent, :children

  @@window = 0

  def initialize(x: 0, y: 0, w: 0, h: 0, r: 240, g: 240, b: 240, text: "Window#{@@window += 1}")
    @x = x
    @y = y
    @w = w
    @h = h
    @r = r
    @g = g
    @b = b
    @text = text

    @children = WindowCollection.new(self)
    @focussed = false
    @pointer_inside = false
  end

  def parent=(new_parent)
    raise ArgumentError, "Cannot change parent of #{inspect} to #{new_parent.inspect} after it's been set" unless @parent.nil?

    @parent = new_parent
  end

  def focussed?
    @focussed
  end

  def focus
    unless @focussed
      notify_observers(Event.new(:focussed, self))
      @focussed = true
    end
  end

  def blur
    if @focussed
      notify_observers(Event.new(:blurred, self))
      @focussed = false
    end
  end

  def blur_children(except = nil)
    @children.each { |child| child.blur unless child == except }
  end

  def focussed_child_index
    @children.index(&:focussed?)
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

  def to_p
    [relative_rect.solid!(color)] + @children.to_p
  end

  def rect
    { x: @x, y: @y, w: @w, h: @h }
  end

  def relative_rect
    { x: relative_x, y: relative_y, w: @w, h: @h }
  end

  def color
    { r: r, g: g, b: b }
  end

  def inspect
    "#<#{self.class.name} #{text}>"
  end
end

class WindowCollection
  extend Forwardable

  def_delegators :@collection, :each, :map, :length, :index, :[]

  def initialize(owner)
    @owner = owner
    @collection = []
  end

  def add(child)
    @collection.push(child)
    child.parent = @owner
    child
  end

  def to_p
    map(&:to_p)
  end
end
