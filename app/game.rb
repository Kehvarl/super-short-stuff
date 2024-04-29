class Game
  def initialize args={}
  end

  def tick args
    if args.inputs.keyboard.key_down.escape
      args.state.game_state = :pause_menu
    end
  end

  def render args
  end
end

class Snake < Game
  def initialize args={}
    @score = 0
    @playfield = {}
    @snake_length = 3
    @snake_direction = [1,0,0]
    @snake_pd = 0
    @snake = [{x:0,y:0,d:0,nd:0}, {x:1,y:0,d:0,nd:0}, {x:2,y:0,d:0,nd:0}]
    @food_count = 3
    @food = []
    @cooldown = 20
  end

  def tick args
    super args
    @cooldown -=1
    if @cooldown <= 0 or args.inputs.keyboard.keys[:down].size > 0
      @cooldown = 20
      turn_tick(args)
    end

    h = @snake[-1]
    fi = @food.select{|f| f.x == h.x and f.y == h.y}
    if fi.size() > 0
      @food = @food.select{|f| f.x != h.x or f.y != h.y}
      @snake_length += 1
      @score += fi[0].score
    end

    if @food.size() < @food_count
      @food << generate_food()
    end
  end

  def check_all_impacts(x, y)
    si = @snake.select{|s| s.x == x and s.y == y}
    fi = @food.select{|f| f.x == x and f.y == y}
    pi = @playfield.select{|p| p.x == x and p.y == y}
    si.size == 1 and (fi.size == 0 and pi.size == 0)
  end

  def generate_food()
    good_food = false
    while not good_food
      fx = [*1..(1280.div(16) -2)].sample
      fy = [*1..(720.div(16) -2)].sample
      good_food = true
      @playfield.each{|p| if p.x == fx and p.y == fy then good_food = false end}
      @snake.each{|s| if s.x == fx and s.y == fy then good_food = false end}
      @food.each{|f| if f.x == fx and f.y == fy then good_food = false end}
    end

    {x:fx, y:fy, score: [100,100,100,250,250,500].sample(), color: ['red', 'red', 'red', 'blue', 'green'].sample()}
  end

  def turn_tick args
    if @snake.size >= @snake_length
      @snake = @snake.drop(1)
    end
    head = @snake[-1].dup()
    @snake[-1].nd = @snake_direction[2]
    head.x += @snake_direction[0]
    head.y += @snake_direction[1]
    head.d = @snake_direction[2]
    head.nd = 0
    if head.x < 0
      head.x = 1280/16
    elsif head.x > 1280/16
      head.x = 0
    end
    if head.y < 0
      head.y = 720/16
    elsif head.y > 720/16
      head.y = 0
    end 

    @snake.append(head)

    @snake_pd = @snake_direction[2]
    if args.inputs.keyboard.key_down.up
      @snake_direction = [0,1,90]
    elsif args.inputs.keyboard.key_down.down
      @snake_direction = [0,-1,270]
    elsif args.inputs.keyboard.key_down.left
      @snake_direction = [-1,0,180]
    elsif args.inputs.keyboard.key_down.right
      @snake_direction = [1,0,0]
    end
  end

  def get_segment(p,n)
    if p == n
      return 'blue.png' #'snake_body.png'
    elsif p-90 == n or (p == 0 and n == 270)
      return 'green.png' #'snake_right.png'
    elsif p+90 == n or (p == 270 and n == 0)
      return 'red.png' #'snake_left.png'
    else
      puts("#{p}, #{n}")
      return 'gray.png' #'snake_body.png'
    end
  end

  def draw_snake
    out = []
    @snake.each do |s|
      #puts(s)
      if s == @snake[-1]
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.d, path: "sprites/circle/green.png"}.sprite!
      else
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.nd, path: "sprites/square/#{get_segment(s.d, s.nd)}"}.sprite!
      end
    end
    out
  end

  def draw_food
    out = []
    @food.each do |f|
      out << {x:f.x*16, y:f.y*16, w:16, h:16, path:"sprites/hexagon/#{f.color}.png"}
    end
    out
  end

  def render
    out = []
    #out << @playfield
    out << draw_snake
    out << draw_food
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
    #puts hp
    if hp != nil
      e.hp = hp
    end
    @entities << e
  end

  def tick args
    super args
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
