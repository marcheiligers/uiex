module Focusable
  def initialize(**args)
    super(args)

    @focussed = false
  end

  def focussed?
    @focussed
  end

  def focus
    return if @focussed

    @focussed = true
    notify_observers(Event.new(:focussed, self))
  end

  def blur
    return unless @focussed

    @focussed = false
    notify_observers(Event.new(:blurred, self))
  end

  def blur_children(except = nil)
    @children.each { |child| child.blur unless child == except }
  end

  def focussed_child_index
    @children.index(&:focussed?)
  end
end
