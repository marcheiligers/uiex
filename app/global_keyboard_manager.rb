class GlobalKeyboardManager
  def initialize
    @debounce_input = DebounceInput.new({ up: :up, right: :up, down: :down, left: :down }, 20, 1, 1)
  end

  def react
    if $args.inputs.keyboard.key_held.m
      case @debounce_input.debounce
      when :up
        if $state.sound.volume < 100
          $state.sound.volume += 1
          $publisher.publish(Event.new(:sound_volume_changed))
        end
      when :down
        if $state.sound.volume > 0
          $state.sound.volume -= 1
          $publisher.publish(Event.new(:sound_volume_changed))
        end
      end
    end
  end

  def play(name)
    $args.audio[name] = { input: "sounds/#{name}.wav", gain: $args.state.sound.volume / 100.0 } if $args.state.sound.enabled
  end
end

$global_keyboard_manager = GlobalKeyboardManager.new
