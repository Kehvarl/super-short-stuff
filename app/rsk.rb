require('app/game.rb')

class AnimSprite
  attr_sprite

  def initialize(x,y)
    @x = x
    @y = y
    @w = 64
    @h = 64
    @path= "sprites/square/green.png"
    @angle= 0
    @tile_x=  0
    @tile_y=  0
    @tile_w= 32
    @tile_h= 32
    @flip_vertically = false
    @flip_horizontally = false

    @current_pose = :idle_lick
    @current_frame = 0
    @frame_duration = 10
    @frame_delay = 10
    @countdown = 0
    @pose_list = {
      #Name: [Row, Frames, Repeat, [Next Anim Options]]
      idle: [0,1,1,[:idle]],
    }
  end

  def tick(args)
    @frame_duration -= 1
    if @frame_duration <= 0
      @frame_duration = @frame_delay
      @current_frame += 1
      if @current_frame >= @pose_list[@current_pose][1]
        @current_frame = 0
        @countdown -= 1
        if @countdown <= 0
          @current_pose = @pose_list[@current_pose][3].sample()
          @countdown = @pose_list[@current_pose][2]
        end
      end
    end
    @tile_x = @current_frame*32
    @tile_y = @pose_list[@current_pose][0]*32
  end

  def bounding_box(color={r:255,g:0,b:0})
    {x:@x, y:@y, w:@w, h:@h, **color}.border!
  end
end

class Cat < AnimSprite
  def initialize (x,y)
    super(x,y)
    @path= "sprites/sheets/cat.png"

    @current_pose = :idle_lick
    @pose_list = {
      sit_down: [0,4,4, [:sit_down, :idle_lick, :idle_sleep]],
      sit_right: [1,4,4, [:sit_right, :idle_lick, :idle_sleep]],
      idle_lick: [2,4,2, [:idle_lick, :idle_ear, :idle_sleep, :arch]],
      idle_ear: [3,4,1, [:idle_lick, :idle_sleep, :arch]],
      prance: [4,8,1, [:sit_down]],
      leap: [5,8,1, [:sit_down]],
      idle_sleep: [6,4,4, [:idle_sleep, :idle_ear, :idle_sleep, :arch]],
      walk: [7,6,1, [:sit_down]],
      pounce: [8,7,1, [:sit_down]],
      arch: [9,8,1, [:sit_down]]
    }
  end
end

class Crab < AnimSprite
  def initialize (x,y)
    super(x,y)
    @path= "sprites/sheets/crab.png"
    @current_pose = :idle
    @pose_list = {
      idle: [0,4,4, [:idle]],
      walk: [1,4,1, [:idle]],
      die: [2,4,1, [:idle]],
      attack: [3,4,1, [:idle]]
    }
  end
end

class Fox < AnimSprite
  def initialize (x,y)
    super(x,y)
    @path= "sprites/sheets/fox.png"

    @current_pose = :idle
    @pose_list = {
      idle: [0,5,4, [:idle, :idle_look]],
      idle_look: [1,14,1, [:idle, :idle_look, :fear, :sleep]],
      walk: [2,8,1, [:idle]],
      attack: [3,11,1, [:idle]],
      fear: [4,5,1, [:idle]],
      sleep: [5,6,3, [:sleep, :idle]],
      die: [6,7,1, [:idle]]
    }
  end
end

class Armadillo < AnimSprite
  def initialize (x,y)
    super(x,y)
    @path= "sprites/sheets/armadillo.png"

    @current_pose = :idle
    @pose_list = {
      idle: [0,8,2, [:idle, :idle_ball]],
      walk: [1,4,1, [:idle]],
      idle_ball: [2,8,1, [:idle, :duck, :die]],
      duck: [3,3,1, [:idle]],
      die: [4,3,1, [:idle]]
    }
  end
end

class Squirrel < AnimSprite
  def initialize (x,y)
    super(x,y)
    @path= "sprites/sheets/squirrel.png"

    @current_pose = :idle
    @pose_list = {
      idle: [0,6,2, [:idle, :idle_look, :idle_forage]],
      idle_look: [1,6,1, [:idle, :idle_look, :hop, :idle_nibble]],
      hop: [2,8,1, [:idle, :fear]],
      idle_forage: [3,4,1, [:idle]],
      idle_nibble: [4,2,1, [:idle]],
      fear: [5,4,1, [:idle]],
      die: [6,4,1, [:idle]]
    }
  end
end

class Rsk < Game
  def initialize args={}
    @robot = {x:632, y:352, w:16, h:32, angle:0}
    @entities = new_entities(1)
    puts @entities
  end

  def new_entities(count)
    out = []
    (0..count).each do
      a = [:armadillo, :crab, :fox, :squirrel].sample
      x = [0..1264].sample
      y = [0..704].sample

      case a
      when :armadillo
        out << Armadillo.new(x,y)
      when :crab
        out << Crab.new(x,y)
      when :fox
        out << Fox.new(x,y)
      when :squirrel
        out << Squirrel.new(x,y)
      end

      x = [0..1264].sample
      y = [0..704].sample
      out << Cat.new(x,y)

      out
    end

  end

  def tick args
    super(args)

    #@entities.each { |e| e.tick(args) }

    if args.inputs.keyboard.key_held.up
      @robot.y += 1
      @robot.angle = 90
    elsif args.inputs.keyboard.key_held.down
      @robot.y -= 1
      @robot.angle = 270
    elsif args.inputs.keyboard.key_held.left
      @robot.x -=1
      @robot.angle = 180
    elsif args.inputs.keyboard.key_held.right
      @robot.x += 1
      @robot.angle = 0
    end

  end

  def render
    out = []
    out << {**@robot, path:"sprites/circle/indigo.png"}.sprite!

    #@entities.each {|c| out << c }

    out
  end
end
