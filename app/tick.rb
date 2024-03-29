NUMBERS = %w[one two three four five six seven eight nine]

def tick(args)
  defaults if args.tick_count == 0

  $global_keyboard_manager.handle_inputs
  $windows.handle_inputs

  args.outputs.primitives << $windows.to_primitives

  NUMBERS.each_with_index do |name, index|
    if args.inputs.keyboard.key_up.send(name) && window = $windows[index]
      window.visible? ? window.hide : window.show
    end
  end

  args.outputs.debug << { x: 700, y: 30, text: "Volume #{args.state.sound.volume}" }.label!
end

def defaults
  $state.debug = true
  $state.sound.volume = 50
  $state.sound.enabled = true

  $windows = WindowCollection.new

  $windows.add(AppearReveal.new(make_menu(40), animation_length: 20))
  $windows.add(DropReveal.new(make_menu(280), animation_length: 20))
  $windows.add(WipeReveal.new(make_menu(520), animation_length: 30))
  $windows.add(FuturisticTvReveal.new(make_menu(760), animation_length: 30))
  $windows.add(ZoomReveal.new(make_menu(1000), animation_length: 20))

  $windows.add(DraggableButton.new(x: 800, y: 100, w: 200, h: 80, text: 'Drag Me'))

  slider = $windows.add(Slider.new(x: 100, y: 100, w: 400, h: 40, text: 50))
  slider.attach_observer(self) do |event|
    $publisher.publish(Event.new(:sound_volume_set, slider)) if event.name == :changed
  end
  $publisher.attach_observer(slider) do |event|
    slider.value = $state.sound.volume if event.name == :sound_volume_changed && event.source != slider
  end
end

def make_menu(x)
  menu = VerticalMenu.new(x: x, y: 300, w: 220, h: 300, padding: 10, spacing: 10, focus_rect: FocusRect.new)
  menu.add_button('First')
  menu.add_separator
  switch = menu.add_item(Switch.new(text: 'Second'))
  switch.attach_observer(self) { |event| switch.set(!switch.on?) if event.name == :pressed }
  menu.add_button('Third')
  menu
end
