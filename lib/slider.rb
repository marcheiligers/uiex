class Slider < Window
  attr_reader :min, :max

  def initialize(**args)
    super(args)

    @min = args[:min] || 0
    @max = args[:max] || 100

    button_size = [@w / 12, @h].min
    button_y = (@h - button_size) / 2

    @button_plus = children.add(Button.new(x: 0, y: button_y, w: button_size, h: button_size, text: '-', color: Color::DARK_GREY, focus_color: Color::RED, text_color: Color::WHITE))
    @button_plus.attach_observer(self) do |event|
      @button_plus.focus if event.name == :mouse_enter
      @button_plus.blur if event.name == :mouse_leave
      self.value -= 1 if event.name == :pressed
    end

    @button_minus = children.add(Button.new(x: @w - button_size, y: button_y, w: button_size, h: button_size, text: '+', color: Color::DARK_GREY, focus_color: Color::RED, text_color: Color::WHITE))
    @button_minus.attach_observer(self) do |event|
      @button_minus.focus if event.name == :mouse_enter
      @button_minus.blur if event.name == :mouse_leave
      self.value += 1 if event.name == :pressed
    end

    @slider = children.add(SliderButton.new(w: button_size, h: button_size, text: 'o', color: Color::DARK_GREY, focus_color: Color::RED, text_color: Color::WHITE))
    @slider.attach_observer(self) do |event|
      @slider.focus if event.name == :mouse_enter
      @slider.blur if event.name == :mouse_leave
    end

    self.value = (args[:text] || 50)
  end

  def value
    @text.to_i
  end

  def value=(val)
    return if val == value
    puts "value=#{val}"
    set_value val
    @slider.position
  end

  def w=(val)
    @w = val
    position_children
  end

  def h=(val)
    @h = val
    position_children
  end

private

  def position_children
    button_size = [@w / 12, @h].min
    button_y = (@h - button_size) / 2

    @button_plus.y = button_y
    @button_plus.w = button_size
    @button_plus.h = button_size

    @button_minus.x = @w - button_size
    @button_minus.y = button_y
    @button_minus.w = button_size
    @button_minus.h = button_size

    @slider.w = button_size
    @slider.h = button_size

    @slider.position
  end

  def set_value(val)
    val = @min if val < @min
    val = @max if val > @max

    @text = val.to_i.to_s

    notify_observers(Event.new(:changed, self))
  end

  class SliderButton < Button
    include Draggable

    def limit_drag
      button_size = [parent.w / 12, parent.h].min
      @y = (parent.h - button_size) / 2

      button_size = [parent.w / 12, parent.h].min
      slider_min_x = button_size
      slider_max_x = button_size * 10
      @x = [[@x, slider_min_x].max, slider_max_x].min

      parent.set_value (@x - slider_min_x) / (slider_max_x - slider_min_x) * (parent.max - parent.min)
    end

    def position
      button_size = [parent.w / 12, parent.h].min
      @y = (parent.h - button_size) / 2

      button_size = [parent.w / 12, parent.h].min
      slider_min_x = button_size
      slider_max_x = button_size * 10
      @x = parent.value / (parent.max - parent.min) * (slider_max_x - slider_min_x) + slider_min_x
    end

    def text
      parent.text
    end
  end
end
