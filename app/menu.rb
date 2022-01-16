
# TODO: touch
module InputEvents
	def input_accepted?
		inputs = $args.inputs
		inputs.mouse.click || inputs.controller_one.key_up.x || inputs.keyboard.key_up.enter || inputs.keyboard.key_up.space
	end
end

class DebounceInput
	# TODO: implement acceleration
	# TODO: initialize with events

	EVENTS = %i[up down]
	DEBOUNCE_TICKS = 20

	def initialize
		@event_ticks = 0
		@event_name = nil
	end

	def debounce
		event_name = EVENTS.detect { |name| $args.inputs.send(name) }
		if @event_name != event_name
			@event_ticks = 0
			@event_name = event_name # returned
		elsif @event_name == event_name
			@event_ticks += 1
			@event_name if @event_ticks % DEBOUNCE_TICKS == 0 # returned
		end
	end
end

class MenuButton
	FOCUSSED = { r: 255, g: 0, b: 0 }
	NORMAL = { r: 128, g: 128, b: 128 }
	TEXT = { r: 255, g: 255, b: 255, vertical_alignment_enum: 0 }

	include InputEvents
	include Observable

	def initialize(x, y, w, h, text)
		@x = x
		@y = y
		@w = w
		@h = h

		@text = text

		@focussed = false
		@pointer_inside = false
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

	def react
		if $args.inputs.mouse.inside_rect?(rect)
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

		if focussed? && input_accepted?
			notify_observers(Event.new(:pressed, self))
		end
	end

	def rect
		{ x: @x, y: @y, w: @w, h: @h }
	end

	def draw
		$args.primitives << [
			rect.solid!(focussed? ? FOCUSSED : NORMAL),
			rect.label!(TEXT.merge({ text: @text }))
		]
	end

	def inspect
		"#<MenuButton #{@text}>"
	end
end

class Menu # VerticalMenu
	def initialize
		@buttons = []
		@debounce_input = DebounceInput.new
	end

	def add_button(text)
		button = MenuButton.new(50, 600 - @buttons.length * 50, 200, 40, text)
		button.attach_observer(self)
		@buttons.push(button)
	end

	def observe(event)
		case event.name
		when :pointer_enter
			event.target.focus
			blur_others(event.target)
		when :pressed
			puts "#{event.target} pressed"
		end
	end

	def blur_others(button)
		@buttons.each { |btn| btn.blur unless btn == button }
	end

	def focussed_index
		@buttons.index(&:focussed?)
	end

	def react
		@buttons.each(&:react)

		case @debounce_input.debounce
		when :up
			index = focussed_index
			index = if index.nil?
								@buttons.length - 1
							else
								index > 0 ? index - 1 : @buttons.length - 1
							end
			@buttons[index].focus
			blur_others(@buttons[index])
		when :down
			index = focussed_index
			index = if index.nil?
								0
							else
								index < @buttons.length - 1 ? index + 1 : 0
							end
			@buttons[index].focus
			blur_others(@buttons[index])
		end
	end

	def draw
		@buttons.each(&:draw)
	end
end
