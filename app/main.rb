
def setup args
  args.state.game_state = :main_menu
end

def main_menu args
  text_color = {r:255, g:255, b:255}
  out = []
  # Draw Banner
  out << {x: 500, y: 650, text: "Super Short Stuff", size_enum: 4, r: 255}.label!
  out << {x: 507, y: 647, text: "Super Short Stuff", size_enum: 3, r: 255, g: 128, b:0}.label!
  out << {x: 514, y: 644, text: "Super Short Stuff", size_enum: 2, r: 255, g: 255, b:0}.label!
  out << {x: 521, y: 641, text: "Super Short Stuff", size_enum: 1, r: 255, g: 255, b:255}.label!

  # Draw Menu Items
  out << {x:540, y:500, text: "1: New Game", **text_color}.label!
  out << {x:540, y:470, text: "2: Blank", **text_color}.label!
  # Track Selected Menu Item
  # Change select with mouse or keyboard
    # Keyboard: Track selected index and increment/decrement
    # Mouse:  On mouse over label, select index
  # On click/enter do something
  # Maybe animate some background stuff

  args.outputs.primitives << out
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
