class UiSoundManager
  def initialize
    $publisher.attach_observer(self)
  end

  def observe(event)
    case event.name
    when :focussed
      play(:ui_focus)
    when :pressed
      play(:ui_press)
    when :sound_volume_changed
      play(:volume_changed)
    end
  end

  def play(name)
    $args.audio[name] = { input: "sounds/#{name}.wav", gain: $args.state.sound.volume / 100.0 } if $args.state.sound.enabled
  end
end

UiSoundManager.new
