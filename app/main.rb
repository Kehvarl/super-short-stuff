
def setup args
  args.state.game_state = :main_menu
end

def main_menu args
  # Draw Banner
  # Draw Menu Items
  # Track Selected Menu Item
  # Change select with mouse or keyboard
    # Keyboard: Track selected index and increment/decrement
    # Mouse:  On mouse over label, select index
  # On click/enter do something
  # Maybe animate some background stuff
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
