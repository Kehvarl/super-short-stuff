class Game
  def initialize args={}
    @gravity = 1
    @drag = 0.1
    @player = {x:0, y:0, w:16, h:32, vx:0, vy:0, path:'sprites/circle/green.png'}.sprite!
  end

  def tick args
    if @player.y > @player.h
      @player.vy -= @gravity
    end
    
    if @player.vx > 0
      @player.vx -= @drag
    elsif @player.vx < 0
      @player.vx += @drag
    end

    if args.inputs.keyboard.up and @player.y <= @player.h
      @player.vy += 10
    elsif args.inputs.keyboard.down
      @player.vy -=1
    end
    if args.inputs.keyboard.left
      @player.vx -=1
    elsif args.inputs.keyboard.right
      @player.vx += 1
    end

    @player.x += @player.vx
    @player.y += @player.vy
    if @player.x <0 or @player.x > 1280-@player.w
      @player.x -= @player.vx
      @player.vx = 0
    end
    if @player.y < @player.h
      @player.vy = 0
      @player.y = @player.h
    end
  end

  def render
    out = []
    out << @player
    out
  end
end
