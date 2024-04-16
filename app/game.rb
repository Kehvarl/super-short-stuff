class Game
  def initialize args={}
  end

  def tick args
  end

  def render args
  end
end

class Snake < Game
  def initialize args={}
    @playfield = {}
    @snake_length = 3
    @snake_direction = [1,0]
    @snake = []
    @food = []
    @cooldown = 20
  end

  def tick args
    @cooldown -=1
    if @cooldown <= 0
      @cooldown = 20
      #turn_tick(args)
    end
  end

  def turn_tick args
    @snake.drop(1)
    head = @snake[-1].dup()
    head.x += @snake_direction[0]
    head.y += @snake_direction[1]
    @snake.append(head)
  end

  def draw_snake
    [
      {x: 0, y: 0, w: 16, h: 16, path: "sprites/square/green.png"}.sprite!,
      {x: 16, y: 0, w: 16, h: 16, path: "sprites/square/green.png"}.sprite!,
      {x: 32, y: 0, w: 16, h: 16, path: "sprites/circle/green.png"}.sprite!,
    ]
  end

  def render
    out = []
    #out << @playfield
    out << draw_snake
    #out << @food
    out
  end
end

class Leap < Game
  def initialize args={}
    # Are gravity and drag global or are they intrinsic to surfaces
    # no drag in flight?
    # lets keep gravity simple for now
    @gravity = 1
    @drag = 0.1
    @max_v = 10
    @player = {x:0, y:0, w:16, h:32, vx:0, vy:0, jump:0, path:'sprites/circle/green.png'}.sprite!
    @map = [
      {x:250, y:100, w:200, h:32, solid:true, path:'sprites/square/gray.png'}.sprite!,
      {x:500, y:200, w:200, h:32, solid:true, path:'sprites/square/gray.png'}.sprite!
    ]
    @entities = []
    @bullets = []

    make_entity(342, 132, hp=nil, path='sprites/circle/yellow.png')
    make_entity(342, 182, hp=nil, path='sprites/circle/blue.png')
    make_entity(500,  32, hp=nil, path='sprites/circle/violet.png')
    make_entity(760, 32, hp=5)

  end

  def make_entity(x, y, hp = nil, path = 'sprites/circle/orange.png')
    e =  {x:x, y:y, w:16, h:32, vx:0, vy:0, jump:0, path:path}.sprite!
    puts hp
    if hp != nil
      e.hp = hp
    end
    @entities << e
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
      @player.vx = [@player.vx-1, -@max_v].max()
    elsif args.inputs.keyboard.right
      @player.vx = [@player.vx+1, @max_v].min()
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
      # TODO: Play pickup animation at collision locaiton
    end
    @entities = @entities.select {|e| !args.geometry.intersect_rect?(e, @player)}

    @bullets.each do |b|
      collisions = args.geometry.find_all_intersect_rect b, @entities
      collisions.each do |bc|
        # If damageable, then to damage
        if bc.hp
          bc.hp -=1
        end
        # TODO: Play shot hit animation
        # TODO: If destroyed, do the thing
      end
    end
    @bullets = @bullets.select{|b| (args.geometry.find_all_intersect_rect b, @entities) == []}
    @entities = @entities.select {|e| (! e.key?(:hp)) or (e.hp > 0)}

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
