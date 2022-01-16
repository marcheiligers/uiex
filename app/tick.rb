$menu = Menu.new
$menu.add_button('First')
$menu.add_button('Second')
$menu.add_button('Third')

$window = Window.new(x: 100, y: 100, w: 100, h: 100)
$window.children.add(Window.new(x: 10, y: 10, w: 50, h: 50, r: 255, g: 0, b: 0))

def tick(args)
  defaults if args.tick_count == 0

  $global_keyboard_manager.react
  $menu.react

  args.outputs.primitives << $menu.to_p

  args.outputs.primitives << $window.to_p

  args.outputs.debug << { x: 700, y: 30, text: "Volume #{args.state.sound.volume}" }.label!
end

def defaults
  $state.debug = true
  $state.sound.volume = 100
  $state.sound.enabled = true

  $menu.appear
end
