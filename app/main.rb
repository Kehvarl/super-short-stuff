require('app/main_menu.rb')

def setup args
  args.state.game_state = :main_menu
  args.state.main_menu = MainMenu.new({})
end

def main_menu_tick args
  args.state.main_menu.tick args
  args.outputs.primitives << args.state.main_menu.render
  if args.state.main_menu.select_event
    puts args.state.main_menu.message
  end
end


def game_over args

end

def tick args
  if args.tick_count == 0
    setup args
  end

  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!

  if args.state.game_state == :main_menu
    main_menu_tick args
  elsif args.state.game_state == :player
    args.state.game_state = :enemy
  elsif args.state.game_State == :enemy
    args.state.game_state = :player
  elsif args.state.game_state == :game_over
    game_over args
  end
end


# TODO
# Draw some terrain
# Draw a character
# Jump
# Collision detection
# Animated Sprite
# Animated Terrain
# Enemies
# Attack Actions
