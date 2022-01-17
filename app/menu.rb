class Menu < Window # VerticalMenu
	def initialize(x:)
    super(x: x, y: 300, w: 220, h: 300, text: 'Menu')
		@debounce_input = DebounceInput.new(up: :up, down: :down)
	end

	def add_button(text)
		button = Button.new(x: 10, y: 250 - children.length * 50, w: 200, h: 40, text: text)
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
