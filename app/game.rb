class Game
  def initialize args={}
    @player = {x:0, y:0, w:16, h:32, vx:0, vy:0, path:'sprites/circle/green.png'}.sprite!
  end

  def tick args
  end

  def render
    out = []
    out << @player
    out
  end
end
