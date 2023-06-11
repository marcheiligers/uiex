module Focusable
  attr_accessor :focussable

  def initialize(**args)
    super(args)

    @focussed = args.fetch(:focussed, false)
    @focussable = args.fetch(:focussable, true) # TODO: should this be the default?
  end

  def focussed?
    @focussed
  end

  def focussable?
    @focussable
  end

  def focus
    return if @focussed || !@focussable

    @focussed = true
    notify_observers(Event.new(:focussed, self))
    self
  end

  def blur
    return unless @focussed

    @focussed = false
    notify_observers(Event.new(:blurred, self))
    self
  end

  def focussable_children
    @children.flat_map do |child|
      if child.children.empty? && child.focussable?
        child
      else
        child.focussable_children
      end
    end
  end

  def focussed_child_index
    focussable_children.index(&:focussed?)
  end

  def blur_children(except = nil)
    focussable_children.each { |child| child.blur unless child == except }
  end

  def prev_focussable_child(cur_index = focussed_child_index)
    fc = focussable_children
    return nil if fc.empty?

    i = cur_index.to_i
    i == 0 ? fc[-1] : fc[i - 1]
  end

  def next_focussable_child(cur_index = focussed_child_index)
    fc = focussable_children
    return nil if fc.empty?

    i = cur_index.nil? ? -1 : cur_index.to_i
    i == fc.length - 1 ? fc[0] : fc[i + 1]
  end
end
