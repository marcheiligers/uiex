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
  $state.sound.volume = 100
  $state.sound.enabled = true

  $windows = WindowCollection.new

  $windows.add(AppearReveal.new(make_menu(40), animation_length: 20))
  $windows.add(DropReveal.new(make_menu(280), animation_length: 20))
  $windows.add(WipeReveal.new(make_menu(520), animation_length: 30))
  $windows.add(FuturisticTvReveal.new(make_menu(760), animation_length: 30))
  $windows.add(ZoomReveal.new(make_menu(1000), animation_length: 20))

  $windows.add(DraggableButton.new(x: 400, y: 400, w: 200, h: 200, text: "Drag Me"))
end

def make_menu(x)
  menu = Menu.new(x: x)
  menu.add_button('First')
  menu.add_button('Second')
  menu.add_button('Third')
  menu
end