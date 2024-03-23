
def setup args
  args.state.game_state = :main_menu
  args.state.frame = 0
  args.state.frame_max = 3
  args.state.frame_v = 1
  args.state.frame_delay = 10
end

def main_menu args
  args.state.frame_delay -=1
  if args.state.frame_delay <= 0
    args.state.frame += args.state.frame_v
    if args.state.frame > args.state.frame_max or args.state.frame < 0
      args.state.frame_v = -args.state.frame_v
      args.state.frame += args.state.frame_v
    end
    args.state.frame_delay = 10
  end
  f = args.state.frame

  text_color = {r:255, g:255, b:255}
  banner_color = [
    [{r: 255, g: 0, b:0}, {r: 192, g: 0, b:0}, {r: 128, g: 0, b:0}, {r: 64, g: 0, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 128, b:0}, {r: 192, g: 64, b:0}, {r: 128, g: 32, b:0}, {r: 64, g: 16, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:0}, {r: 192, g: 192, b:0}, {r: 128, g: 128, b:0}, {r: 64, g: 64, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:255}, {r: 192, g: 192, b:192}, {r: 128, g: 128, b:128}, {r: 64, g: 64, b:64}, {r: 32, g: 32, b:32}],
  ]
  out = []
  # Draw Banner
  out << {x: 500, y: 650, text: "Super Short Stuff", size_enum: 4, **banner_color[0][f]}.label!
  out << {x: 507, y: 647, text: "Super Short Stuff", size_enum: 3, **banner_color[1][f]}.label!
  out << {x: 514, y: 644, text: "Super Short Stuff", size_enum: 2, **banner_color[2][f]}.label!
  out << {x: 521, y: 641, text: "Super Short Stuff", size_enum: 1, **banner_color[3][f]}.label!

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
