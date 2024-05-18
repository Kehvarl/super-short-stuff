
class Snake < Game
  def initialize args={}
    @score = 0
    @playfield = []
    # Need to rework the playfield and make only 2 edges instead of 4 top and bottom are the same edge
    # left and right are also the same edge
    @playfield_model = [[{x:0,y:0,w:1,h:(720/16),block:true}, {x:0,y:0,w:(1280/16),h:1,block:true}],
                        #{x:(1280/16)-1,y:0,w:1,h:(720/16),block:true}, {x:0,y:(720/16)-1,w:(1280/16),h:1,block:true}],
                      ]
    @snake_length = 3
    @snake_direction = [1,0,0]
    @snake_pd = 0
    @snake = [{x:1,y:1,d:0,nd:0}, {x:2,y:1,d:0,nd:0}, {x:3,y:1,d:0,nd:0}]
    @snake_block_snake = false
    @snake_damage_snake = true
    @head_colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet']
    @head_color = 'green'
    @head_delay = 600
    @food_count = 3
    @food = []
    @cooldown = 20

    build_playfield(0)
  end

  def build_playfield(level=0)
    @playfield_model[level].each do |p|
      (0..p.w-1).each do |pw|
        (0..p.h-1).each do |ph|
          @playfield << {x: pw + p.x, y: ph + p.y}
        end
      end
    end
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
      if fi[0].color == @head_color
        @score += fi[0].score * 2
        @head_delay = 0
      else
        @score += fi[0].score
      end
    end

    if @food.size() < @food_count
      @food << generate_food()
    end

    @head_delay -= 1
    if @head_delay <= 0
      @head_delay = 600
      @head_color = @head_colors.sample
    end
  end

  def handle_keypress args
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

  def make_head head
    head.x += @snake_direction[0]
    head.y += @snake_direction[1]
    head.d = @snake_direction[2]
    head.nd = 0
    if head.x < 0
      head.x = 78
    elsif head.x > 78
      head.x = 0
    end
    if head.y < 0
      head.y = 43
    elsif head.y > 43
      head.y = 0
    end

    head
  end

  def turn_tick args
    while @snake.size > @snake_length
      @snake = @snake.drop(1)
    end
    @snake_pd = @snake_direction[2]

    @snake[-1].nd = @snake_direction[2]
    head = make_head(@snake[-1].dup())
    @snake.append(head)

    handle_keypress(args)

    pi = @playfield.select{|p| p.x == head.x and p.y == head.y}
    #puts("#{@snake[-1]}, #{pi}")
    if pi.size() > 0 and pi[0].block == true
      @snake_length -= 1
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
      #puts("#{p}, #{n}")
      return 'gray.png' #'snake_body.png'
    end
  end

  def draw_playfield
    out = []
    @playfield.each do |p|
      out << {x:p.x*16, y:p.y*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      if p.x == 0
        out << {x:79*16, y:p.y*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      end
      if p.y == 0
        out << {x:p.x*16, y:44*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      end
    end
    out
  end

  def draw_snake
    out = []
    @snake.each do |s|
      #puts(s)
      if s == @snake[-1]
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.d, path: "sprites/circle/#{@head_color}.png"}.sprite!
      else
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.nd, path: "sprites/square/#{get_segment(s.d, s.nd)}"}.sprite!
      end
      if s.x == 0
        if s == @snake[-1]
          out << {x:79*16, y:s.y*16, w:16, h:16, angle:s.d, path:"sprites/circle/#{@head_color}.png"}.sprite!
        else
          out << {x:79*16, y:s.y*16, w:16, h:16, angle:s.nd, path:"sprites/square/#{get_segment(s.d, s.nd)}"}.sprite!
        end
      end
      if s.y == 0
        if s == @snake[-1]
          out << {x:s.x*16, y:44*16, w:16, h:16, angle:s.d, path:"sprites/circle/#{@head_color}.png"}.sprite!
        else
          out << {x:s.x*16, y:44*16, w:16, h:16, angle:s.nd, path:"sprites/square/#{get_segment(s.d, s.nd)}"}.sprite!
        end
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
    out << draw_playfield
    out << draw_snake
    out << draw_food
    out
  end
end
