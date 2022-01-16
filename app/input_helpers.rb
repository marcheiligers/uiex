# TODO: touch
module InputEvents
  def input_accepted?
    inputs = $args.inputs
    inputs.mouse.click || inputs.controller_one.key_up.x || inputs.keyboard.key_up.enter || inputs.keyboard.key_up.space
  end
end

class DebounceInput
  def initialize(events, max_ticks = 20, accel = 0, min_ticks = 3)
    @events = events
    @max_ticks = max_ticks
    @accel = accel
    @min_ticks = min_ticks

    @event_ticks = 0
    @event_name = nil
    @current_debounce_ticks = @max_ticks
  end

  def debounce
    _input, event_name = @events.detect { |input, _name| $args.inputs.send(input) }
    if @event_name != event_name
      @event_ticks = 0
      @current_debounce_ticks = @max_ticks
      @event_name = event_name # returned
    elsif @event_name == event_name
      @event_ticks += 1
      if @event_ticks % @current_debounce_ticks == 0
        @current_debounce_ticks = [@current_debounce_ticks - @accel, @min_ticks].max
        @event_name # returned
      end
    end
  end
end
