class GlobalKeyboardManager
  def initialize
    @debounce_input = DebounceInput.new({ up: :up, right: :up, down: :down, left: :down }, 20, 1, 1)
  end

  def handle_inputs
    return unless $args.inputs.keyboard.key_held.m

    case @debounce_input.debounce
    when :up
      $publisher.publish(Event.new(:sound_volume_up))
    when :down
      $publisher.publish(Event.new(:sound_volume_down))
    end
  end
end

$global_keyboard_manager = GlobalKeyboardManager.new
