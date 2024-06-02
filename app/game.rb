class Game
  def initialize args={}
  end

  def tick args
    if args.inputs.keyboard.key_down.escape
      args.state.game_state = :pause_menu
    end
  end

  def render
  end
end
