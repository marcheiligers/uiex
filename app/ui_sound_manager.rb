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
    $args.audio[name] = { input: "sounds/#{name}.wav", gain: $state.sound.volume / 100.0 } if $state.sound.enabled
  end
end

UiSoundManager.new

class VolumeManager
  def initialize
    $publisher.attach_observer(self)
  end

  def observe(event)
    case event.name
    when :sound_volume_up
      if $state.sound.volume < 100
        $state.sound.volume += 1
        $publisher.publish(Event.new(:sound_volume_changed))
      end
    when :sound_volume_down
      if $state.sound.volume > 0
        $state.sound.volume -= 1
        $publisher.publish(Event.new(:sound_volume_changed))
      end
    when :sound_volume_set
      if $state.sound.volume != event.value
        $state.sound.volume = event.value
        $publisher.publish(Event.new(:sound_volume_changed))
      end
    end
  end
end

VolumeManager.new
