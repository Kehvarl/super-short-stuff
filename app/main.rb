require('app/main_menu.rb')
require('app/game.rb')
require('app/leaper.rb')
require('app/snake.rb')
require('app/lindwurm.rb')
require('app/rsk.rb')

def setup args
  args.state.game_state = :main_menu
  args.state.main_menu = MainMenu.new({})
end

def main_menu_tick args
  args.state.main_menu.tick args
  args.outputs.primitives << args.state.main_menu.render
  if args.state.main_menu.select_event
    puts args.state.main_menu.message
    if args.state.main_menu.message == :newgame_snake
      args.state.game = Snake.new(args)
      args.state.game_state = :game
    elsif args.state.main_menu.message == :newgame_lindwurm
      args.state.game = LindWurm.new(args)
      args.state.game_state = :game
    elsif args.state.main_menu.message == :newgame_leap
      args.state.game = Leap.new({})
      args.state.game_state = :game
    elsif args.state.main_menu.message == :newgame_rsk
      args.state.game = Rsk.new(args)
      args.state.game_state = :game
    elsif args.state.main_menu.message == :continue
      args.state.game_state = :game
    end
  end
end


def game_over args

end

def tick args
  if args.tick_count == 0
    setup args
  end

  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!

  case args.state.game_state
  when :main_menu
    main_menu_tick args
  when :pause_menu
    main_menu_tick args
  when :game
    args.state.game.tick args
    args.outputs.primitives << args.state.game.render()
  when :player
    args.state.game_state = :enemy
  when :enemy
    args.state.game_state = :player
  when :game_over
    game_over args
  end
end

# TODO
# Background is needed
# Also a map of some sort
# Need some actual game concept
  # We know its a platformer
  # What is the main character
  # What sort of Enemies
  # How does the world move
  # Would it be worhtwhile to start over from the platformer demo code?
# Draw some terrain - done
# Draw a character - done
# Jump - done
# Collision detection
  # Ground - done
  # Sides  - done
  # Terrain - done
  # Entities - done
# Animated Sprite
# Animated Terrain
# Enemies
# Attack Actions
