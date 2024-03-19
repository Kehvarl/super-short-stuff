
def setup args
  args.state.game_state = :main_menu
end

def main_menu args
  
end

def game_over args
  
end

def tick args
  if args.tick_count == 0
    setup args
  end
  
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!

  if args.state.game_state == :main_menu
    main_menu args
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
