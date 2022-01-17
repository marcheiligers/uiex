class MenuButton < Window
	FOCUSSED = { r: 255, g: 0, b: 0 }
	NORMAL = { r: 128, g: 128, b: 128 }
	TEXT = { r: 255, g: 255, b: 255, vertical_alignment_enum: 1, alignment_enum: 1 }

	def initialize(x, y, w, h, text)
    super(x: x, y: y, w: w, h: h, text: text)
	end

	def handle_inputs
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

	def to_primitives
		[
			relative_rect.solid!(focussed? ? FOCUSSED : NORMAL),
			relative_center.label!(TEXT.merge({ text: text }))
		]
	end
end

class Menu < Window # VerticalMenu
	def initialize(x:)
    super(x: x, y: 300, w: 220, h: 300, text: 'Menu')
		@debounce_input = DebounceInput.new(up: :up, down: :down)
	end

	def add_button(text)
		button = MenuButton.new(10, 250 - children.length * 50, 200, 40, text)
		button.attach_observer(self)
    children.add(button)
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

	def handle_inputs
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
end
