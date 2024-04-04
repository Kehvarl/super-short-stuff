class Game
  def initialize args={}
    # Are gravity and drag global or are they intrinsic to surfaces
    # no drag in flight?
    # lets keep gravity simple for now
    @gravity = 1
    @drag = 0.1
    @player = {x:0, y:0, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/green.png'}.sprite!
    @map = [
      {x:250, y:100, w:200, h:32, solid:true, path:'sprites/square/gray.png'}.sprite!,
      {x:500, y:200, w:200, h:32, solid:true, path:'sprites/square/gray.png'}.sprite!
    ]
    @entities = [
      {x:342, y:132, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/yellow.png'}.sprite!,
      {x:342, y:182, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/yellow.png'}.sprite!,
      {x:592, y:232, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/yellow.png'}.sprite!,
      {x:592, y:32, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/yellow.png'}.sprite!

    ]
    @bullets = []
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

    @bullets.each {|b| b.x += b.vx}

    if args.inputs.keyboard.key_down.up and @player.jump < 2
      @player.jump += 1
      @player.vy = @player.jump * 10
    elsif args.inputs.keyboard.down
      @player.vy -=1
    end
    if args.inputs.keyboard.left
      @player.vx -=1
    elsif args.inputs.keyboard.right
      @player.vx += 1
    end

    if args.inputs.keyboard.key_down.space
      @bullets << {x:@player.x+@player.w, y:@player.y+4, w:4, h:4, vx:@player.vx+5, r:0, g:128, b:128}.solid!
    end

    @player.x += @player.vx
    @player.y += @player.vy
    if @player.x <0 or @player.x > 1280-@player.w
      @player.x -= @player.vx
      @player.vx = -@player.vx
    end

    collision = args.geometry.find_intersect_rect @player, @map
    if collision and collision.y >= @player.y
      @player.vy = -1
    elsif collision and collision.y <= @player.y
      @player.vy = 0
      @player.jump = 0
      @player.y = collision.y + @player.h
    end

    collision = args.geometry.find_intersect_rect @player, @entities
    if collision
      # Play pickup animation at collision locaiton
    end
    @entities = @entities.select {|e| !args.geometry.intersect_rect?(e, @player)}

    @bullets.each do |b|
      collisions = args.geometry.find_all_intersect_rect b, @entities
      collisions.each do |bc|
        puts bc
        # If damageable, then to damage
        # Play shot hit animation
        # If destroyed, do the thing
      end
    end
    @bullets = @bullets.select{|b| (args.geometry.find_all_intersect_rect b, @entities) == []}



    if @player.y < @player.h
      @player.vy = 0
      @player.jump = 0
      @player.y = @player.h
    end
  end

  def render
    out = []
    out << @player
    out << @entities
    out << @bullets
    out << @map
    out
  end
end
