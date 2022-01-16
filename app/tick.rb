$menu = Menu.new
$menu.add_button('First')
$menu.add_button('Second')
$menu.add_button('Third')

def tick(args)
  defaults if args.tick_count == 0

  $menu.react
  $menu.draw
end

def defaults
  $args.state.sound.volume = 100
  $args.state.sound.enabled = true
end
