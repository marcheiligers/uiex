class MenuButton < Window
	FOCUSSED = { r: 255, g: 0, b: 0 }
	NORMAL = { r: 128, g: 128, b: 128 }
	TEXT = { r: 255, g: 255, b: 255, vertical_alignment_enum: 1, alignment_enum: 1 }

	def initialize(x, y, w, h, text)
    super(x: x, y: y, w: w, h: h, text: text)
	end

	def react
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

	def to_p
		[
			relative_rect.solid!(focussed? ? FOCUSSED : NORMAL),
			relative_center.label!(TEXT.merge({ text: text }))
		]
	end
end

class Menu < Window # VerticalMenu
  include Easing

	def initialize
    super(x: 40, y: 1020, w: 220, h: 300, text: 'Menu')
		@debounce_input = DebounceInput.new(up: :up, down: :down)
	end

	def add_button(text)
		button = MenuButton.new(10, 250 - children.length * 50, 200, 40, text)
		button.attach_observer(self)
    children.add(button)
	end

  def appear
    @appear_ticks = 0
  end

  def to_p
    if !@appear_ticks.nil? && @appear_ticks < 60
      @appear_ticks += 1
      @y = (1 - ease_out_elastic(@appear_ticks, 60)) * h + 300
    end

    super
  end

	def observe(event)
		case event.name
		when :pointer_enter
			event.target.focus
			blur_children(event.target)
		when :pressed
			puts "#{event.target} pressed"
		end
	end

	def react
		children.each(&:react)

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
end
